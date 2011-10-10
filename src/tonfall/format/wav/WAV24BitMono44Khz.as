package tonfall.format.wav
{
    import tonfall.format.pcm.PCM24BitMono44Khz;

    /**
     * @author Andre Michelle
     */
    public final class WAV24BitMono44Khz extends PCM24BitMono44Khz implements IWAVIOStrategy
    {
        public static const INSTANCE:IWAVIOStrategy = new WAV24BitMono44Khz();

        public function WAV24BitMono44Khz()
        {
            super(1);
        }
    }
}
