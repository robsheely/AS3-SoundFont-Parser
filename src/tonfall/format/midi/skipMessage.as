package tonfall.format.midi {
	import flash.utils.ByteArray;
	public function skipMessage( stream: ByteArray ): void
	{
		var c: int;
		
		do
		{
			c = stream.readUnsignedByte();
		}
		while( c < 0x80 );

		stream.position--;
	}
}