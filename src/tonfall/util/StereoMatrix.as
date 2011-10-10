package tonfall.util
{
	import tonfall.core.Signal;

	/**
	 * The class StereoMatrix let you transform incoming stereo signals in panorama space
	 * 
	 * @author Andre Michelle
	 */
	public final class StereoMatrix
	{
		public var lr: Number; // left to right
		public var rl: Number; // right to left
		public var ll: Number; // left to left
		public var rr: Number; // right to right

		public function StereoMatrix( gain: Number = 1.0 )
		{
			identity( gain );
		}
		
		/**
		 * Transforms signal into panorama space
		 * Inline it for optimisation!
		 * 
		 * @param source The signal to read incoming audio
		 * @param target The signal to write transformed audio
		 */
		public function transform( source: Signal, target: Signal ): void
		{
			const sl: Number = source.l;
			const sr: Number = source.r;

			target.l = sl * ll + sr * rl;
			target.r = sl * lr + sr * rr;
		}
		
		/**
		 * Computes multipliers for transforming incoming audio in panorama
		 * 
		 * @param gain The volume after translation
		 * @param pan The panning ratio (-1: left, 0: center, +1: right)
		 */
		public function linear( gain: Number, pan: Number ): void
		{
			//-- CLAMP
			if( gain < 0.0 )
				gain = 0.0;
			else
			if( gain > 1.0 )
				gain = 1.0;
			
			if( pan < -1.0 )
				pan = -1.0;
			else
			if( pan > 1.0 )
				pan = 1.0;

			if( pan < 0.0 ) // LEFT
			{
				lr = 0.0;
				ll = gain;
				rl = -pan * gain;
				rr = ( pan + 1.0 ) * gain;
			}
			else
			if( pan > 0.0 ) // RIGHT
			{
				lr = pan * gain;
				ll = ( 1.0 - pan ) * gain;
				rl = 0.0;
				rr = gain;
			}
			else // CENTER
			{
				lr =
				rl = 0.0;
				ll =
				rr = gain;
			}
		}
		
		/**
		 * Merge stereo signal into mono
		 */
		public function mono( gain: Number = 1.0 ): void
		{
			lr =
			rl =
			ll =
			rr = gain;
		}

		/**
		 * Identity matrix
		 */
		public function identity( gain: Number = 1.0 ): void
		{
			lr =
			rl = 0.0;
			ll = gain;
			rr = gain;
		}

		public function toString(): String
		{
			return 'StereoMatrix ' +
					'leftToRight: ' + lr +
					', rightToLeft: ' + rl +
					', leftToLeft: ' + ll +
					', rightToRight: ' + rr +
					']';
		}
	}
}
