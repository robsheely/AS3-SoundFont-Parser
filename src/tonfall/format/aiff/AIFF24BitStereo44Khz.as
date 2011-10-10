package tonfall.format.aiff
{
	import tonfall.format.pcm.PCM24BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF24BitStereo44Khz extends PCM24BitStereo44Khz
		implements IAIFFIOStrategy
	{
		public static const INSTANCE: IAIFFIOStrategy = new AIFF24BitStereo44Khz();
		
		public function AIFF24BitStereo44Khz()
		{
			super( AIFFTags.SSND );
		}
	}
}