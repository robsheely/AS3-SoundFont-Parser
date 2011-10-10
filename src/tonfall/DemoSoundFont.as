package tonfall
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;

    import com.ferretgodmother.soundfont.SoundFontParser;
    import com.ferretgodmother.soundfont.demo.SoundFontVoiceFactory;
    import com.ferretgodmother.soundfont.demo.assets.Midi;

    import tonfall.core.TimeEventContainer;
    import tonfall.core.TimeEventContainerSequencer;
    import tonfall.display.AbstractApplication;
    import tonfall.format.wav.WAVDecoder;
    import tonfall.prefab.poly.PolySynth;

    [SWF(backgroundColor = "#EDEDED", frameRate = "31", width = "1000", height = "1000")]
    public final class MidiSoundFontPlayer extends AbstractApplication
    {
        protected static const BUFFER_SIZE:int = 2048;

        protected var _fileRef:FileReference = new FileReference();
        protected var _textField:TextField = new TextField();
        protected var _memory:ByteArray = new ByteArray();
        protected var _container:TimeEventContainer = Midi.BUBBLE_BOBBLE.toTimeEventContainer();
        protected var _sequencer:TimeEventContainerSequencer = new TimeEventContainerSequencer(_container);
        protected var _generator:PolySynth;
        protected var _inited:Boolean = false;
        protected var _parser:SoundFontParser = new SoundFontParser();
        protected var _firstRun:Boolean = true;

        public function MidiSoundFontPlayer()
        {
            _generator = new PolySynth(new SoundFontVoiceFactory(_parser));
            _textField.autoSize = TextFieldAutoSize.LEFT;
            _textField.defaultTextFormat = new TextFormat('Verdana', 10, 0x666666, true);
            _textField.text = 'Click to browse from your local harddrive\n';
            addChild(_textField);
            stage.addEventListener(MouseEvent.CLICK, click);
        }

        protected function click(event:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.CLICK, click);
            if (_firstRun)
            {
                _firstRun = false;
            }
            else
            {
                _textField.text = 'Browsing\n';
            }
            browseSF2();
        }

        protected function browseSF2():void
        {
            _generator.clear();
            this.driver.running = false;
            this.engine.barPosition = 0.0;
            // allocate memory (sizeof float:4) * 2
            _memory.length = BUFFER_SIZE << 3;
            _fileRef.addEventListener(Event.SELECT, fileRef_onSelect);
            _fileRef.addEventListener(Event.CANCEL, fileRef_onCancel);
            _fileRef.browse([new FileFilter('Soundfont', '.sf2')]);
        }

        protected function fileRef_onCancel(event:Event):void
        {
            _textField.appendText('Bye bye.\n');
            _fileRef.removeEventListener(Event.CANCEL, fileRef_onCancel);
            _fileRef.removeEventListener(Event.SELECT, fileRef_onSelect);
        }

        protected function fileRef_onSelect(event:Event):void
        {
            _fileRef.removeEventListener(Event.CANCEL, fileRef_onCancel);
            _fileRef.removeEventListener(Event.SELECT, fileRef_onSelect);
            _fileRef.addEventListener(Event.COMPLETE, fileRef_onComplete);
            _fileRef.load();
        }

        protected function fileRef_onComplete(event:Event):void
        {
            _fileRef.removeEventListener(Event.COMPLETE, fileRef_onComplete);
            _textField.appendText('Loaded ' + _fileRef.name + '\n');
            _parser.bytes = _fileRef.data;
            //trace(SoundFontParser(_parser).toString());
            //_textField.appendText('[Sound Font]: ' + SoundFontParser(_parser).toString());
            this.driver.running = true;
            init();
        }

        private function init():void
        {
            if (!_inited)
            {
                _sequencer.timeEventTarget = _generator;
                this.engine.processors.push(_sequencer);
                this.engine.processors.push(_generator);
                this.engine.input = _generator.signalOutput;
                _inited = true;
            }
        }
    }
}
