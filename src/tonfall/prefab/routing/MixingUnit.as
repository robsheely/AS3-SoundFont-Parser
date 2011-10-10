package tonfall.prefab.routing
{
    import tonfall.core.Signal;
    import tonfall.core.SignalBuffer;
    import tonfall.core.SignalProcessor;

    /**
     * Simple MixingUnit
     *
     * Caution: No interpolation between different gains and pannings.
     *
     * @author Andre Michelle
     */
    public final class MixingUnit extends SignalProcessor
    {
        public const signalOutput:SignalBuffer = new SignalBuffer();
        private var _numInputs:uint;
        private var _inputs:Vector.<SignalBuffer>;
        private var _gains:Vector.<Number>;
        private var _pans:Vector.<Number>;

        public function MixingUnit(numInputs:uint)
        {
            _numInputs = numInputs;
            _inputs = new Vector.<SignalBuffer>(numInputs, true);
            _gains = new Vector.<Number>(numInputs, true);
            _pans = new Vector.<Number>(numInputs, true);
            for (var i:int = 0; i < numInputs; ++i)
            {
                _gains[i] = 0.7;
            } // DEFAULT GAIN
        }

        /**
         * Connect a SignalBuffer with passed index
         */
        public function connectAt(output:SignalBuffer, index:int):void
        {
            _inputs[index] = output;
        }

        /**
         * Disconnect SignalBuffer at passed index
         */
        public function disconnectAt(index:int):void
        {
            _inputs[index] = null;
        }

        /**
         * @param gain Value between zero and one
         */
        public function setGainAt(gain:Number, index:int):void
        {
            _gains[index] = gain;
        }

        public function getGainAt(index:int):Number
        {
            return _gains[index];
        }

        /**
         * @param pan Value between -1 (left) and +1 (right)
         */
        public function setPanAt(pan:Number, index:int):void
        {
            _pans[index] = pan;
        }

        public function getPanAt(index:int):Number
        {
            return _pans[index];
        }

        override protected function processSignals(numSignals:int):void
        {
            var input:SignalBuffer;
            var first:Boolean = true;
            const out:Signal = signalOutput.current;
            const n:int = _inputs.length;
            for (var i:int = 0; i < n; ++i)
            {
                input = _inputs[i];
                if (null == input)
                {
                    continue;
                }
                //-- CONSTANT POWER PANNING
                //   0 is center (gain: 1 / sqrt(2))
                //  -1 is full left
                //  +1 is full right
                var x:Number = (_pans[i] + 1.0) * Math.PI * 0.25;
                var y:Number = _gains[i];
                var gainL:Number = Math.cos(x) * y;
                var gainR:Number = Math.sin(x) * y;
                if (first)
                {
                    processReplace(input.current, out, numSignals, gainL, gainR);
                    first = false;
                }
                else
                {
                    processAdd(input.current, out, numSignals, gainL, gainR);
                }
            }
        }

        private function processReplace(inp:Signal, out:Signal, numSignals:int, gainL:Number, gainR:Number):void
        {
            for (var i:int = 0; i < numSignals; ++i)
            {
                out.l = inp.l * gainL;
                out.r = inp.r * gainR;
                out = out.next;
                inp = inp.next;
            }
        }

        private function processAdd(inp:Signal, out:Signal, numSignals:int, gainL:Number, gainR:Number):void
        {
            for (var i:int = 0; i < numSignals; ++i)
            {
                out.l += inp.l * gainL;
                out.r += inp.r * gainR;
                out = out.next;
                inp = inp.next;
            }
        }
    }
}
