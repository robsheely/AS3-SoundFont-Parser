package tonfall.format.pcm
{
    import flash.utils.ByteArray;

    /**
     * @author Andre Michelle
     */
    public class PCMEncoder
    {
        private var _bytes:ByteArray;
        private var _strategy:IPCMIOStrategy;
        private var _samplePosition:uint;

        public function PCMEncoder(strategy:IPCMIOStrategy)
        {
            if (null == strategy)
            {
                throw new Error('strategy must not be null');
            }
            _strategy = strategy;
            _samplePosition = 0;
            _bytes = new ByteArray();
            writeHeader(_bytes);
        }

        /**
         * Writes audio data to wav format
         *
         * @param data ByteArray consisting audio format (44100,Stereo,Float)
         * @param numSamples number of samples to be processed
         */
        public function write32BitStereo44KHz(data:ByteArray, numSamples:uint):void
        {
            _strategy.write32BitStereo44KHz(data, _bytes, numSamples);
            _samplePosition += numSamples;
            const position:uint = _bytes.position;
            updateHeader(_bytes, _samplePosition);
            _bytes.position = position;
        }

        /**
         * @return file
         */
        public function get bytes():ByteArray
        {
            return _bytes;
        }

        /**
         * @return file extension
         */
        public function get fileExt():String
        {
            return '.raw';
        }

        public function get strategy():IPCMIOStrategy
        {
            return _strategy;
        }

        public function dispose():void
        {
            _bytes = null;
        }

        protected function writeHeader(bytes:ByteArray):void
        {
        }

        protected function updateHeader(bytes:ByteArray, totalSamples:uint):void
        {
        }
    }
}
