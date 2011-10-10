package tonfall.format.aiff
{
	import tonfall.format.pcm.PCM8BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF8BitStereo44Khz extends PCM8BitStereo44Khz
		implements IAIFFIOStrategy
	{
		public static const INSTANCE: IAIFFIOStrategy = new AIFF8BitStereo44Khz();

		public function AIFF8BitStereo44Khz()
		{
			super( true, AIFFTags.SSND );
		}
	}
}
