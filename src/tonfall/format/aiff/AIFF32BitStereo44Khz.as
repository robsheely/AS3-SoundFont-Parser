package tonfall.format.aiff
{
	import tonfall.format.pcm.PCM32BitIntStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF32BitStereo44Khz extends PCM32BitIntStereo44Khz
		implements IAIFFIOStrategy
	{
		public static const INSTANCE: IAIFFIOStrategy = new AIFF32BitStereo44Khz();

		public function AIFF32BitStereo44Khz()
		{
			super( AIFFTags.SSND );
		}
	}
}