package tonfall.format.pcm
{
	import tonfall.core.Signal;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitIntStereo44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		public function PCM32BitIntStereo44Khz( compressionType: Object = null )
		{
			super( compressionType, 44100.0, 2, 32 );
		}
		
		public function readFrameInSignal( data : ByteArray, dataOffset : Number, signal : Signal, position : Number ) : void
		{
			throw new Error( 'Not implemented. Lazy.' );
		}

		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 3 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( data.readInt() / 0x7FFFFFFF );
				target.writeFloat( data.readInt() / 0x7FFFFFFF );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				if( left > 1.0 )
					target.writeInt( 0x7FFFFFFF );
				else
				if( left < -1.0 )
					target.writeInt( -0x7FFFFFFF );
				else
					target.writeInt( left * 0x7FFFFFFF );

				const right : Number = data.readFloat();
				
				if( right > 1.0 )
					target.writeInt( 0x7FFFFFFF );
				else
				if( right < -1.0 )
					target.writeInt( -0x7FFFFFFF );
				else
					target.writeInt( right * 0x7FFFFFFF );
			}
		}
	}
}
