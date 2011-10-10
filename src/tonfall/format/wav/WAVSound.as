package tonfall.format.wav
{
    import flash.utils.ByteArray;
    import tonfall.format.pcm.PCMSound;

    public final class WAVSound extends PCMSound
    {
        public function WAVSound(bytes:ByteArray, onComplete:Function = null)
        {
            super(bytes, WAVDecoder.parseHeader(bytes), onComplete);
        }
    }
}
