package tonfall.format.wav
{
    import tonfall.format.pcm.PCM8BitMono44Khz;

    /**
     * @author Andre Michelle
     */
    public final class WAV8BitMono44Khz extends PCM8BitMono44Khz implements IWAVIOStrategy
    {
        public static const INSTANCE:IWAVIOStrategy = new WAV8BitMono44Khz();

        public function WAV8BitMono44Khz()
        {
            super(false, 1);
        }
    }
}
