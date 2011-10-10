package tonfall.core
{
    import flash.utils.ByteArray;

    /**
    * Engine runs the digital audio processing chain
    * and writes the last SignalBuffer into a ByteArray.
    *
    * It also stores the current time position in bars and beats per minutes.
    *
    * The processing chain needs to be setup manually.
    *
    * @author Andre Michelle
    *
    * @see Driver
    * @see Processor
    */
    public final class Engine
    {
        private static var instance:Engine = null;

        public static function getInstance():Engine
        {
            if (null == instance)
            {
                instance = new Engine();
            }
            return instance;
        }

        private const blockInfo:BlockInfo = new BlockInfo();

        private var _barPosition:Number; // BAR POSITION
        private var _bpm:Number; // BEATS PER MINUTE
        private var _processors:Vector.<Processor>; // LINEAR LIST OF PROCESSORS
        private var _input:SignalBuffer;

        public function Engine()
        {
            if (instance != null)
            {
                throw new Error('AudioEngine is Singleton.');
            }
            _barPosition = 0.0;
            _bpm = 120.0;
            _processors = new Vector.<Processor>();
        }

        /**
        * @return Current musical position in bars
        */
        public function get barPosition():Number
        {
            return _barPosition;
        }

        /**
        * Sets musical position in bars.
        * Not to be set while processing!
        *
        * @param value The new position in bars
        */
        public function set barPosition(value:Number):void
        {
            _barPosition = value;
        }

        /**
        * @return The current tempo in beats per minute (bpm)
        */
        public function get bpm():Number
        {
            return _bpm;
        }

        /**
        * Sets tempo in beats per minute (bpm)
        * Not to be set while processing!
        *
        * @param value The new tempo in bpm
        */
        public function set bpm(value:Number):void
        {
            _bpm = value;
        }

        /**
        * Direct access to the processing chain.
        *
        * @return Linear processing list
        */
        public function get processors():Vector.<Processor>
        {
            return _processors;
        }

        /**
        * Assign last signal buffer.
        * The processed audio in there will be written into the target ByteArray.
        *
        * @param value The SignalBuffer to be read
        */
        public function set input(value:SignalBuffer):void
        {
            _input = value;
        }

        /**
        * This method allows you to get the local offset in signals inside a block
        *
        * @param position A musical time within the current block
        * @return The number of signals till the passed musical position
        *
        * @see SignalProcessor
        */
        public function deltaBlockIndexAt(position:Number):int
        {
            const value:int = TimeConversion.barsToNumSamples(position - _barPosition, _bpm);
            if (value < 0 || value >= blockSize)
            {
                throw new Error('Index out of Block. index: ' + value);
            }
            return value;
        }

        /**
        * @param target The ByteArray to be filled with audio
        * @param numSignals The number of signals to be processed
        */
        internal function render(target:ByteArray):void
        {
            const to:Number = _barPosition + TimeConversion.numSamplesToBars(blockSize, _bpm);
            blockInfo.reset(blockSize, _barPosition, to);
            renderProcessors();
            _barPosition = to;
            if (null != _input)
            {
                writeInput(target);
            }
        }

        private function renderProcessors():void
        {
            var n:int = _processors.length;
            for (var i:int = 0; i < n; ++i)
            {
                _processors[i].process(blockInfo);
            }
        }

        private function writeInput(target:ByteArray):void
        {
            var signal:Signal = _input.current;
            const n:int = blockSize;
            for (var i:int = 0; i < n; ++i)
            {
                target.writeFloat(signal.l);
                target.writeFloat(signal.r);
                signal = signal.next;
            }
        }
    }
}
