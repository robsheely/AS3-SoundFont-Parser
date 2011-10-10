package tonfall.format.pcm
{
	import tonfall.core.Signal;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitFloatMono44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		public function PCM32BitFloatMono44Khz( compressionType: Object = null )
		{
			super( compressionType, 44100.0, 1, 32 );
		}
		
		public function readFrameInSignal( data : ByteArray, dataOffset : Number, signal : Signal, position : Number ) : void
		{
			data.position = dataOffset + ( position << 2 );
			
			signal.l =
			signal.r = data.readFloat();
		}
		
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 2 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude: Number = data.readFloat();
				
				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = ( data.readFloat() + data.readFloat() ) * 0.5;
				
				target.writeFloat( amplitude );
			}
		}
	}
}
