package tonfall.util
{
	/**
	 * Creates basic waveforms
	 * 
	 * @author Andre Michelle
	 */
	public final class WaveFunction
	{
		/**
		 * @param phase a value between zero and one
		 * @return bipolar /\ waveform
		 */
		static public function biTriangle( phase : Number ) : Number
		{
			if( 0.5 > phase ) return phase * 4.0 - 1.0;
			
			return 3.0 - phase * 4.0;
		}

		/**
		 * @param phase a value between zero and one
		 * @return bipolar ~ sinus
		 */
		static public function biSinus( phase : Number ) : Number
		{
			return Math.sin( phase * 2.0 * Math.PI );
		}

		/**
		 * @param phase a value between zero and one
		 * @return bipolar / sawtooth
		 */
		static public function biSawtooth( phase : Number ) : Number
		{
			return phase * 2.0 - 1.0;
		}

		/**
		 * @param phase a value between zero and one
		 * @return bipolar [ square
		 */
		static public function biSquare( phase : Number, width : Number = 0.5 ) : Number
		{
			return phase < width ? 1.0 : -1.0;
		}
		
		/**
		 * @param phase a value between zero and one
		 * @return normalized /\ waveform
		 */
		static public function normTriangle( phase : Number ) : Number
		{
			if( 0.5 > phase ) return phase * 2.0;

			return 2.0 - phase * 2.0;
		}

		/**
		 * @param phase a value between zero and one
		 * @return normalized ~ sinus
		 */
		static public function normSinus( phase : Number ) : Number
		{
			return Math.sin( phase * 2.0 * Math.PI ) * 0.5 + 0.5;
		}

		/**
		 * @param phase a value between zero and one
		 * @return normalized / sawtooth
		 */
		static public function normSawtooth( phase : Number ) : Number
		{
			return phase;
		}

		/**
		 * @param phase a value between zero and one
		 * @return normalized [ square
		 */
		static public function normSquare( phase : Number, width : Number = 0.5 ) : Number
		{
			return phase < width ? 1.0 : 0.0;
		}
	}
}
