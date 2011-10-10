package tonfall.format.wav
{
    import tonfall.format.pcm.PCM16BitMono44Khz;

    /**
    * @author Andre Michelle
    */
    public final class WAV16BitMono44Khz extends PCM16BitMono44Khz implements IWAVIOStrategy
    {
        public static const INSTANCE:IWAVIOStrategy = new WAV16BitMono44Khz();

        public function WAV16BitMono44Khz()
        {
            super(1);
        }
    }
}
