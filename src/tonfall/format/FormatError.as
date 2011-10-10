package tonfall.format
{
	/**
	 * @author Andre Michelle
	 */
	public final class FormatError extends Error
	{
		public static const UNKNOWN: FormatError = new FormatError( 'Unknown Error' );
		public static const HEADER_CORRUPT: FormatError = new FormatError( 'Header corrupt' );
		public static const SIZE_MISMATCH: FormatError = new FormatError( 'Wrong size' );
		public static const TAG_MISMATCH: FormatError = new FormatError( 'Wrong tag' );
		public static const TAG_UNKNOWN: FormatError = new FormatError( 'Unknown tag' );
		public static const COMPRESSION_TYPE: FormatError = new FormatError( 'CompressionType not supported' );
		public static const SAMPLING_RATE: FormatError = new FormatError( 'SamplingRate not supported' );
		public static const NUM_CHANNELS: FormatError = new FormatError( 'NumChannels not supported' );
		public static const BIT: FormatError = new FormatError( 'Bit size not supported' );
		
		public function FormatError( message: String )
		{
			super( message );
		}
	}
}