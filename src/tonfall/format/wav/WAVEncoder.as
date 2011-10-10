package tonfall.format.wav
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import tonfall.format.pcm.PCMEncoder;

    /**
     * @author Andre Michelle
     */
    public final class WAVEncoder extends PCMEncoder
    {
        private var _dtlo:uint; // store data tag length offset for writing later

        public function WAVEncoder(strategy:IWAVIOStrategy)
        {
            super(strategy);
        }

        /**
         * @return file extension
         */
        override public function get fileExt():String
        {
            return '.wav';
        }

        override protected function writeHeader(bytes:ByteArray):void
        {
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.writeUnsignedInt(WAVTags.RIFF);
            bytes.writeUnsignedInt(0);
            bytes.writeUnsignedInt(WAVTags.WAVE);
            bytes.writeUnsignedInt(WAVTags.FMT);
            bytes.writeUnsignedInt(16); // chunk length
            bytes.writeShort(int(strategy.compressionType)); // compression
            bytes.writeShort(strategy.numChannels); // numChannels
            bytes.writeUnsignedInt(strategy.samplingRate); // samplingRate
            bytes.writeUnsignedInt(strategy.samplingRate * strategy.blockAlign); // bytesPerSecond
            bytes.writeShort(strategy.blockAlign); // blockAlign
            bytes.writeShort(strategy.bits); // bits
            bytes.writeUnsignedInt(WAVTags.DATA);
            _dtlo = bytes.position;
            bytes.writeUnsignedInt(0);
        }

        override protected function updateHeader(bytes:ByteArray, totalSamples:uint):void
        {
            const position:uint = bytes.position;
            // WRITE FILE SIZE
            bytes.position = 4;
            bytes.writeUnsignedInt(bytes.length - 8);
            // WRITE AUDIO SIZE
            bytes.position = _dtlo;
            bytes.writeUnsignedInt(totalSamples * strategy.blockAlign);
            // REVERT POSITION
            bytes.position = position;
        }
    }
}
