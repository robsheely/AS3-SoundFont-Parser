package tonfall.prefab.poly
{
    import tonfall.core.Parameter;
    import tonfall.core.Signal;
    import tonfall.core.SignalBuffer;
    import tonfall.core.SignalProcessor;
    import tonfall.core.TimeEvent;
    import tonfall.core.TimeEventNote;

    /**
    * PolySynth provides a simple way to create a polyphone synthesizer.
    *
    * @author Andre Michelle
    */
    public final class PolySynth extends SignalProcessor
    {
        public const signalOutput:SignalBuffer = new SignalBuffer();
        public const paramVolume:Parameter = new Parameter('volume', 1.0);

        private const activeVoices:Vector.<IPolySynthVoice> = new Vector.<IPolySynthVoice>();

        private var _voicefactory:IPolySynthVoiceFactory;

        public function PolySynth(voicefactory:IPolySynthVoiceFactory)
        {
            _voicefactory = voicefactory;
        }

        public function clear():void
        {
            while (activeVoices.length)
            {
                IPolySynthVoice(activeVoices.pop()).dispose();
            }
        }

        override protected function processTimeEvent(event:TimeEvent):void
        {
            if (event is TimeEventNote)
            {
                startVoice(TimeEventNote(event));
            }
        }

        override protected function processSignals(numSignals:int):void
        {
            signalOutput.zero(numSignals);
            var current:Signal = signalOutput.current;
            var i:int = activeVoices.length;
            while (--i > -1)
            {
                if (activeVoices[i].processAdd(current, numSignals))
                {
                    activeVoices.splice(i, 1);
                }
            }
            signalOutput.multiply(numSignals, paramVolume.value);
            signalOutput.advancePointer(numSignals);
        }

        private function startVoice(event:TimeEventNote):void
        {
            const voice:IPolySynthVoice = _voicefactory.create(event);

            voice.start(event);
            activeVoices.push(voice);
        }
    }
}