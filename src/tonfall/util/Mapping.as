package tonfall.util
{
	/**
	 * @author Andre Michelle
	 */
	public final class Mapping
	{
		public static function mapLinear( normalized:Number, min: Number, max: Number ): Number
		{
			return min + normalized * ( max - min );
		}
		
		public static function mapLinearInv( value:Number, min: Number, max: Number ): Number
		{
			return ( value - min ) / ( max - min );
		}

		public static function mapExp( normalized:Number, min: Number, max: Number ):Number
		{
			return min * Math.exp( normalized * Math.log( max / min ) );
		}
	}
}