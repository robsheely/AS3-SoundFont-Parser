package tonfall.format.pcm
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import tonfall.core.Signal;

    /**
     * @author Andre Michelle
     */
    public class PCM24BitMono44Khz extends PCMStrategy implements IPCMIOStrategy
    {
        private static const bytes:ByteArray = createByteArray();

        private static function createByteArray():ByteArray
        {
            const bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.length = 4;
            return bytes;
        }

        public function PCM24BitMono44Khz(compressionType:Object = null)
        {
            super(compressionType, 44100.0, 1, 24);
        }

        public function readFrameInSignal(data:ByteArray, dataOffset:Number, signal:Signal, position:Number):void
        {
            data.position = dataOffset + position * 3;
            signal.l =
                signal.r =
                int((data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24)) *
                0.000000000465661; // DIV 0x80000000
        }

        public function read32BitStereo44KHz(data:ByteArray, dataOffset:Number, target:ByteArray, length:Number,
                                             startPosition:Number):void
        {
            data.position = dataOffset + startPosition * 3;
            for (var i:int = 0; i < length; ++i)
            {
                const amplitude:Number =
                    int((data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24)) *
                    0.000000000465661; // DIV 2147483648
                target.writeFloat(amplitude);
                target.writeFloat(amplitude);
            }
        }

        public function write32BitStereo44KHz(data:ByteArray, target:ByteArray, numSamples:uint):void
        {
            for (var i:int = 0; i < numSamples; ++i)
            {
                const amplitude:Number = (data.readFloat() + data.readFloat()) * 0.5;
                bytes.position = 0;
                if (amplitude > 1.0)
                {
                    bytes.writeInt(0x7FFFFFFF);
                }
                else if (amplitude < -1.0)
                {
                    bytes.writeInt(0x80000000);
                }
                else
                {
                    bytes.writeInt(amplitude * 0x80000000);
                }
                target.writeBytes(bytes, 1, 3);
            }
        }
    }
}
