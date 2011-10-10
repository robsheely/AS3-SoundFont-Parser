package tonfall.format.aiff
{
    import flash.utils.ByteArray;
    import tonfall.format.FormatError;
    import tonfall.format.FormatInfo;
    import tonfall.format.pcm.PCMSound;

    public final class AIFFSound extends PCMSound
    {
        public function AIFFSound(bytes:ByteArray, onComplete:Function = null)
        {
            super(bytes, AIFFDecoder.parseHeader(bytes), onComplete);
        }

        override protected function writeSoundData(swf:ByteArray, data:ByteArray, info:FormatInfo):void
        {
            if (2 != info.numChannels)
            {
                throw FormatError.NUM_CHANNELS;
            }
            var i:int;
            var n:int;
            if (8 == info.bits)
            {
                // signed > unsigned
                data.position = info.dataOffset;
                i = 0;
                n = info.dataLength;
                for (; i < n; ++i)
                {
                    swf.writeByte(data.readByte() + 0x80);
                }
            }
            else
            {
                // 16bit (big > little endien)
                data.position = info.dataOffset;
                i = 0;
                n = info.numSamples;
                for (; i < n; ++i)
                {
                    swf.writeShort(data.readShort());
                    swf.writeShort(data.readShort());
                }
            }
        }
    }
}
