package tonfall.format.pcm
{
    import flash.utils.ByteArray;
    import tonfall.core.Signal;

    /**
     * @author Andre Michelle
     */
    public class PCM16BitStereo44Khz extends PCMStrategy implements IPCMIOStrategy
    {
        public function PCM16BitStereo44Khz(compressionType:Object = null)
        {
            super(compressionType, 44100.0, 2, 16);
        }

        public function readFrameInSignal(data:ByteArray, dataOffset:Number, signal:Signal, position:Number):void
        {
            data.position = dataOffset + (position << 2);
            signal.l = data.readShort() * 3.051850947600e-05;
            signal.r = data.readShort() * 3.051850947600e-05;
        }

        public function read32BitStereo44KHz(data:ByteArray, dataOffset:Number, target:ByteArray, length:Number,
                                             startPosition:Number):void
        {
            data.position = dataOffset + (startPosition << 2);
            for (var i:int = 0; i < length; ++i)
            {
                target.writeFloat(data.readShort() * 3.051850947600e-05); // DIV 0x7FFF
                target.writeFloat(data.readShort() * 3.051850947600e-05); // DIV 0x7FFF
            }
        }

        public function write32BitStereo44KHz(data:ByteArray, target:ByteArray, numSamples:uint):void
        {
            for (var i:int = 0; i < numSamples; ++i)
            {
                const left:Number = data.readFloat();
                if (left > 1.0)
                {
                    target.writeShort(0x7FFF);
                }
                else if (left < -1.0)
                {
                    target.writeShort(-0x7FFF);
                }
                else
                {
                    target.writeShort(left * 0x7FFF);
                }
                const right:Number = data.readFloat();
                if (right > 1.0)
                {
                    target.writeShort(0x7FFF);
                }
                else if (right < -1.0)
                {
                    target.writeShort(-0x7FFF);
                }
                else
                {
                    target.writeShort(right * 0x7FFF);
                }
            }
        }
    }
}
