package tonfall.format.pcm
{
    import tonfall.format.FormatInfo;

    /**
     * @author Andre Michelle
     */
    public class PCMStrategy
    {
        private var _compressionType:Object;
        private var _samplingRate:Number;
        private var _numChannels:uint;
        private var _bits:uint;

        public function PCMStrategy(compressionType:Object, samplingRate:Number, numChannels:uint, bits:uint)
        {
            _compressionType = compressionType;
            _samplingRate = samplingRate;
            _numChannels = numChannels;
            _bits = bits;
        }

        public final function supports(info:FormatInfo):Boolean
        {
            return _compressionType == info.compressionType && _samplingRate == info.samplingRate &&
                _numChannels == info.numChannels && _bits == info.bits;
        }

        public final function get compressionType():Object
        {
            return _compressionType;
        }

        public final function get samplingRate():Number
        {
            return _samplingRate;
        }

        public final function get numChannels():uint
        {
            return _numChannels;
        }

        public final function get bits():uint
        {
            return _bits;
        }

        public final function get blockAlign():uint
        {
            return (_numChannels * _bits) >> 3;
        }
    }
}
