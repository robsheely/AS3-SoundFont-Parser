package tonfall.format.pcm
{
    import flash.utils.ByteArray;
    import tonfall.core.Signal;
    import tonfall.format.IAudioDecoder;

    /**
    * @author Andre Michelle
    */
    public class PCMDecoder implements IAudioDecoder
    {
        private var _bytes:ByteArray;
        private var _strategy:IPCMIOStrategy;

        public function PCMDecoder(bytes:ByteArray, strategy:IPCMIOStrategy)
        {
            if (null == bytes)
            {
                throw new Error('bytes must not be null');
            }
            _bytes = bytes;
            _strategy = strategy;
        }

        public function get seconds():Number
        {
            return numSamples / _strategy.samplingRate;
        }

        /**
        * @return number of samples converted to target samplingRate (In Flash only 44100Hz)
        */
        public function getNumSamples(targetRate:Number = 44100.0):Number
        {
            if (_strategy.samplingRate == targetRate)
            {
                return numSamples;
            }
            else
            {
                return Math.floor(numSamples * targetRate / _strategy.samplingRate);
            }
        }

        /**
        * Decodes audio from format into Flashplayer sound properties (stereo,float,44100Hz)
        *
        * @return The number of samples has been read
        */
        public function extract(target:ByteArray, length:Number, startPosition:Number = -1.0):Number
        {
            if (startPosition >= numSamples)
            {
                return 0.0;
            }
            if (startPosition + length > numSamples)
            {
                length = numSamples - startPosition;
            }
            _strategy.read32BitStereo44KHz(_bytes, dataOffset, target, length, startPosition);
            return length;
        }

        /**
        * Decodes a single frame into a Signal
        */
        public function readFrame(signal:Signal, position:uint):void
        {
            _strategy.readFrameInSignal(_bytes, dataOffset, signal, position);
        }

        public function get supported():Boolean
        {
            return null != _strategy;
        }

        public function get compressionType():*
        {
            return _strategy.compressionType;
        }

        public function get numSamples():Number
        {
            return _bytes.length / _strategy.blockAlign;
        }

        public function get samplingRate():Number
        {
            return _strategy.samplingRate;
        }

        public function get numChannels():int
        {
            return _strategy.numChannels;
        }

        public function get bits():int
        {
            return _strategy.bits;
        }

        public function get blockAlign():int
        {
            return _strategy.blockAlign;
        }

        public function get dataOffset():Number
        {
            return 0;
        }

        public function get bytes():ByteArray
        {
            return _bytes;
        }

        public function dispose():void
        {
            _bytes = null;
        }

        public function toString():String
        {
            return '[Decoder strategy: ' + _strategy + ', numSamples: ' + numSamples + ']';
        }
    }
}
