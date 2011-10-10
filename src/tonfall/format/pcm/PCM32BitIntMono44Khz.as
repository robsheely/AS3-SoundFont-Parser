package tonfall.format.pcm
{
	import tonfall.core.Signal;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitIntMono44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		public function PCM32BitIntMono44Khz( compressionType: Object = null )
		{
			super( compressionType, 44100.0, 1, 32 );
		}
		
		public function readFrameInSignal( data : ByteArray, dataOffset : Number, signal : Signal, position : Number ) : void
		{
			throw new Error( 'Not implemented. Lazy.' );
		}
		
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 2 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude: Number = data.readInt() / 0x7FFFFFFF;
				
				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = ( data.readFloat() + data.readFloat() ) * 0.5;
				
				if( amplitude > 1.0 )
					target.writeInt( 0x7FFFFFFF );
				else
				if( amplitude < -1.0 )
					target.writeInt( -0x7FFFFFFF );
				else
					target.writeInt( amplitude * 0x7FFFFFFF );
			}
		}
	}
}
