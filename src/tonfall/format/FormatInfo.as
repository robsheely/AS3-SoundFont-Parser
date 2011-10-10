package tonfall.format
{
    /**
     * @author Andre Michelle
     */
    public final class FormatInfo
    {
        private var _compressionType:Object;
        private var _samplingRate:Number;
        private var _numChannels:uint;
        private var _bits:uint;
        private var _numSamples:Number;
        private var _dataOffset:Number;
        private var _blockAlign:uint;

        public function FormatInfo(compressionType:Object, samplingRate:Number, numChannels:uint, bits:uint,
                                   numSamples:Number, dataOffset:Number = 0.0)
        {
            _compressionType = compressionType;
            _samplingRate = samplingRate;
            _numChannels = numChannels;
            _bits = bits;
            _numSamples = numSamples;
            _dataOffset = dataOffset;
            _blockAlign = (bits * numChannels) >> 3;
        }

        public function get compressionType():Object
        {
            return _compressionType;
        }

        public function get samplingRate():Number
        {
            return _samplingRate;
        }

        public function get numChannels():uint
        {
            return _numChannels;
        }

        public function get bits():uint
        {
            return _bits;
        }

        public function get numSamples():Number
        {
            return _numSamples;
        }

        public function get dataOffset():Number
        {
            return _dataOffset;
        }

        public function get dataLength():Number
        {
            return _numSamples * _blockAlign;
        }

        public function get blockAlign():uint
        {
            return _blockAlign;
        }

        public function toString():String
        {
            return '[AudioFormatHeader compressionType: ' + _compressionType + ', samplingRate: ' + _samplingRate +
                ', numChannels: ' + _numChannels + ', bits: ' + _bits + ', blockAlign: ' + _blockAlign +
                ', numSamples: ' + _numSamples + ', dataOffset: ' + _dataOffset + ']';
        }
    }
}
