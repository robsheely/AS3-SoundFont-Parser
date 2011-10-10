package tonfall.format.wav
{
	import tonfall.format.pcm.PCM32BitFloatStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitStereo44Khz extends PCM32BitFloatStereo44Khz
		implements IWAVIOStrategy
	{
		public static const INSTANCE: IWAVIOStrategy = new WAV32BitStereo44Khz();

		public function WAV32BitStereo44Khz()
		{
			super( 3 );
		}
	}
}