package com.ferretgodmother.soundfont.demo
{
    import flash.events.Event;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    import com.ferretgodmother.soundfont.SoundFont;
    import com.ferretgodmother.soundfont.SoundFontParser;
    import com.ferretgodmother.soundfont.demo.SoundFontVoiceFactory;

    import tonfall.core.blockSize;
    import tonfall.core.Driver;
    import tonfall.core.Engine;
    import tonfall.core.Memory;
    import tonfall.core.TimeEventContainer;
    import tonfall.core.TimeEventContainerSequencer;
    import tonfall.display.AbstractApplication;
    import tonfall.format.wav.WAVDecoder;
    import tonfall.prefab.poly.PolySynth;
    import mx.core.UIComponent;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import tonfall.format.midi.MidiFormat;

    public class MidiSoundFontPlayer extends EventDispatcher
    {
        // Kreisleriana, Opus 16 (1838) - Robert Schumann
        [Embed(source = 'assets/schumann.mid', mimeType = 'application/octet-stream')]
        protected static const SCHUMANN_CLASS:Class;

        protected const driver:Driver = Driver.getInstance();
        protected const engine:Engine = Engine.getInstance();

        protected var _container:TimeEventContainer;
        protected var _sequencer:TimeEventContainerSequencer;
        protected var _generator:PolySynth;
        protected var _soundFont:SoundFont;
        protected var _inited:Boolean = false;

        public function MidiSoundFontPlayer()
        {
            var schumann:MidiFormat = MidiFormat.decode(new SCHUMANN_CLASS());
            _container = schumann.toTimeEventContainer();
        }

        public function get soundFont():SoundFont
        {
            return _soundFont;
        }

        public function set soundFont(value:SoundFont):void
        {
            _soundFont = value;
        }

        public function get isPlaying():Boolean
        {
            return this.driver.running;
        }

        public function stop():void
        {
            this.driver.running = false;
            if (_generator != null)
            {
                _generator.clear();
            }
            _generator = null;
        }

        public function play():void
        {
            if (_generator != null)
            {
                _generator.clear();
            }
            _generator = new PolySynth(new SoundFontVoiceFactory(_soundFont));
            this.driver.running = false;
            this.engine.barPosition = 0.0;
            _sequencer = new TimeEventContainerSequencer(_container);
            _sequencer.timeEventTarget = _generator;
            this.engine.processors[0] = _sequencer;
            this.engine.processors[1] = _generator;
            this.engine.input = _generator.signalOutput;
            // preallocate memory for processing single block
            Memory.length = blockSize << 3;
            driver.engine = engine;
            // delay call to avoid glitches (Flashplayer issue)
            if (!_inited)
            {
                _inited = true;
                setTimeout(driver.init, 100);
            }
            this.driver.running = true;
        }

        protected function format_onProgress(event:Event):void
        {
            dispatchEvent(event);
        }
    }
}
