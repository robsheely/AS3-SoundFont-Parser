package tonfall.format.wav
{
    import tonfall.format.pcm.PCM24BitStereo44Khz;

    /**
     * @author Andre Michelle
     */
    public final class WAV24BitStereo44Khz extends PCM24BitStereo44Khz implements IWAVIOStrategy
    {
        public static const INSTANCE:IWAVIOStrategy = new WAV24BitStereo44Khz();

        public function WAV24BitStereo44Khz()
        {
            super(1);
        }
    }
}
