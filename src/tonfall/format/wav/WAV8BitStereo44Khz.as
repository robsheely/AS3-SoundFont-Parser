package tonfall.format.wav
{
    import tonfall.format.pcm.PCM8BitStereo44Khz;

    /**
     * @author Andre Michelle
     */
    public final class WAV8BitStereo44Khz extends PCM8BitStereo44Khz implements IWAVIOStrategy
    {
        public static const INSTANCE:IWAVIOStrategy = new WAV8BitStereo44Khz();

        public function WAV8BitStereo44Khz()
        {
            super(false, 1);
        }
    }
}
