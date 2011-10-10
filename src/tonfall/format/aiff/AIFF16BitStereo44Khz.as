package tonfall.format.aiff
{
	import tonfall.format.pcm.PCM16BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF16BitStereo44Khz extends PCM16BitStereo44Khz
		implements IAIFFIOStrategy
	{
		public static const INSTANCE: IAIFFIOStrategy = new AIFF16BitStereo44Khz();
		
		public function AIFF16BitStereo44Khz()
		{
			super( AIFFTags.SSND );
		}
	}
}