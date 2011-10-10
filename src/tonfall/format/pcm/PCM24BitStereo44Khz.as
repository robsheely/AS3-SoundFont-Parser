package tonfall.format.pcm
{
	import tonfall.core.Signal;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public class PCM24BitStereo44Khz extends PCMStrategy
		implements IPCMIOStrategy
	{
		private static const bytes: ByteArray = createByteArray();

		private static function createByteArray(): ByteArray
		{
			const bytes: ByteArray = new ByteArray();
			
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.length = 4;
			
			return bytes;
		}
		
		public function PCM24BitStereo44Khz( compressionType: Object = null )
		{
			super( compressionType, 44100.0, 2, 24 );
		}
		
		public function readFrameInSignal( data : ByteArray, dataOffset : Number, signal : Signal, position : Number ) : void
		{
			data.position = dataOffset + position * 6;
			
			signal.l = int( ( data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24 ) ) * 0.000000000465661; // DIV 0x80000000
			signal.r = int( ( data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24 ) ) * 0.000000000465661; // DIV 0x80000000
		}
		
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + startPosition * 6;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( int( ( data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24 ) ) * 0.000000000465661 ); // DIV 0x80000000
				target.writeFloat( int( ( data.readUnsignedByte() << 8 | data.readUnsignedByte() << 16 | data.readUnsignedByte() << 24 ) ) * 0.000000000465661 ); // DIV 0x80000000
			}
		}

		/**
		 * TODO Check again: This creates some nasty overtones
		 */
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				bytes.position = 0;
				
				if( left > 1.0 )
					bytes.writeInt( 0x7FFFFFFF );
				else
				if( left < -1.0 )
					bytes.writeInt( -0x7FFFFFFF );
				else
					bytes.writeInt( left * 0x7FFFFFFF );

				target.writeBytes( bytes, 1, 3 );
				
				const right : Number = data.readFloat();
				
				bytes.position = 0;
				
				if( right > 1.0 )
					bytes.writeInt( 0x7FFFFFFF );
				else
				if( right < -1.0 )
					bytes.writeInt( -0x7FFFFFFF );
				else
					bytes.writeInt( right * 0x7FFFFFFF );

				target.writeBytes( bytes, 1, 3 );
			}
		}
	}
}
