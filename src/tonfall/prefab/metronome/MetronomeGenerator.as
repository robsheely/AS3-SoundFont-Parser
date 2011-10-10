package tonfall.prefab.metronome
{
    import tonfall.core.Signal;
    import tonfall.core.SignalBuffer;
    import tonfall.core.SignalProcessor;
    import tonfall.core.TimeEvent;
    import tonfall.core.noteToFrequency;
    import tonfall.core.samplingRate;

    /**
     * Sound Generator for Metronome (sinus, monophone)
     *
     * @author Andre Michelle
     */
    public final class MetronomeGenerator extends SignalProcessor
    {
        public const output:SignalBuffer = new SignalBuffer();
        private const duration:int = samplingRate * 0.050; // 50ms
        private var _phase:Number;
        private var _phaseIncr:Number;
        private var _remaining:int;

        public function MetronomeGenerator()
        {
        }

        override protected function processTimeEvent(event:TimeEvent):void
        {
            if (event is MetronomeEvent)
            {
                _phase = 0.0;
                _remaining = duration;
                if (0 == MetronomeEvent(event).beat)
                {
                    _phaseIncr = noteToFrequency(84) / samplingRate;
                }
                else
                {
                    _phaseIncr = noteToFrequency(72) / samplingRate;
                }
            }
        }

        override protected function processSignals(numSignals:int):void
        {
            var envelope:Number;
            var amplitude:Number;
            var signal:Signal = output.current;
            for (var i:int = 0; i < numSignals; ++i)
            {
                if (_remaining)
                {
                    envelope = (--_remaining) / duration; // LINEAR \
                    amplitude = Math.sin(_phase * 2.0 * Math.PI) * envelope;
                    signal.l = signal.r = amplitude;
                    _phase += _phaseIncr;
                    if (_phase >= 1.0)
                    {
                        _phase -= 1.0;
                    }
                }
                else
                {
                    signal.l = 0.0;
                    signal.r = 0.0;
                }
                signal = signal.next;
            }
            output.advancePointer(numSignals);
        }
    }
}
