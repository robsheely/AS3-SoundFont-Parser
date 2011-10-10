package com.ferretgodmother.soundfont.utils
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class SFByteArray extends ByteArray
    {
        public function SFByteArray(source:ByteArray = null)
        {
            this.endian = Endian.LITTLE_ENDIAN;
            super();
            if (source != null)
            {
                writeBytes(source);
                this.position = 0;
            }
        }

        public function readWord():uint
        {
            return super.readUnsignedShort();
        }

        public function readDWord():uint
        {
            return super.readUnsignedInt();
        }

        public function readString(length:int = -1):String
        {
            length = (length == -1) ? this.bytesAvailable : length;
            return super.readUTFBytes(length);
        }

        public function writeWord(word:int):void
        {
            writeByte(word % 256);
            word /= 256;
            writeByte(word % 256);
        }

        public function writeDWord(dWord:uint):void
        {
            super.writeUnsignedInt(dWord);
        }

        public function writeString(string:String):void
        {
            super.writeUTFBytes(string);
        }

        public function skip(numBytes:uint):void
        {
            this.position += numBytes;
        }
    }
}