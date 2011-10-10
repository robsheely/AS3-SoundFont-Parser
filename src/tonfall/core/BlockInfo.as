package tonfall.core
{
    /**
     * BlockInfo describes all time information to process a single audio block
     *
     * @see Processor
     *
     * @author Andre Michelle
     */
    public final class BlockInfo
    {
        // How many signals should be processed
        private var _numSignals:int;
        // What is the musical time of the block in bars (one bar is 4 quarter notes where signature is 4/4)
        private var _barFrom:Number;
        private var _barTo:Number;

        public function get numSignals():int
        {
            return _numSignals;
        }

        public function get barFrom():Number
        {
            return _barFrom;
        }

        public function get barTo():Number
        {
            return _barTo;
        }

        public function toString():String
        {
            return '[BlockInfo numSignals: ' + _numSignals + ', barFrom: ' + _barFrom.toFixed(3) + ', barTo: ' +
                _barTo.toFixed(3) + ']';
        }

        internal function reset(numSignals:int, from:Number, to:Number):void
        {
            _numSignals = numSignals;
            _barFrom = from;
            _barTo = to;
        }
    }
}
