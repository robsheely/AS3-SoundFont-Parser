package tonfall.format.pcm
{
	import tonfall.core.Signal;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM8BitStereo44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		private var _signed: Boolean;

		public function PCM8BitStereo44Khz( signed: Boolean, compressionType: Object = null )
		{
			super( compressionType, 44100.0, 2, 8 );
			
			_signed = signed;
		}
		
		public function readFrameInSignal( data : ByteArray, dataOffset : Number, signal : Signal, position : Number ) : void
		{
			data.position = dataOffset + ( position << 1 );
			
			signal.l = data.readByte() / 0x7F;
			signal.r = data.readByte() / 0x7F;
		}

		final public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 1 );
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < length ; ++i )
				{
					target.writeFloat( data.readByte() / 0x7F );
					target.writeFloat( data.readByte() / 0x7F );
				}
			}
			else
			{
				for ( i = 0 ; i < length ; ++i )
				{
					target.writeFloat( ( data.readUnsignedByte() - 0x7F ) / 0x7F );
					target.writeFloat( ( data.readUnsignedByte() - 0x7F ) / 0x7F );
				}
			}
		}
		
		final public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			var left : Number;
			var right : Number;
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					left = data.readFloat();
					
					if( left > 1.0 )
						target.writeByte( 0x7F );
					else
					if( left < -1.0 )
						target.writeByte( -0x7F );
					else
						target.writeByte( left * 0x7F );
	
					right = data.readFloat();
					
					if( right > 1.0 )
						target.writeByte( 0x7F );
					else
					if( right < -1.0 )
						target.writeByte( -0x7F );
					else
						target.writeByte( right * 0x7F );
				}
			}
			else
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					left = data.readFloat();
					
					if( left > 1.0 )
						target.writeByte( 0xFF );
					else
					if( left < -1.0 )
						target.writeByte( 0x00 );
					else
						target.writeByte( left * 0x7F + 0x7F );
	
					right = data.readFloat();
					
					if( right > 1.0 )
						target.writeByte( 0xFF );
					else
					if( right < -1.0 )
						target.writeByte( 0x00 );
					else
						target.writeByte( right * 0x7F + 0x7F );
				}
			}
		}
	}
}
