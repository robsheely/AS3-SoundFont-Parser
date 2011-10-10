package tonfall.format.midi {
	import flash.utils.ByteArray;		public function readVarLen( stream: ByteArray ): uint
	{
		var value: uint = stream.readUnsignedByte( );
		var c: int;
		
		if( value & 0x80 )
		{
			value &= 0x7f;
			
			do
			{
				c = stream.readUnsignedByte( );
				
				value = ( value << 7 ) + ( c & 0x7f );
			}
			while( c & 0x80 );
		}

		return value;
	}
}