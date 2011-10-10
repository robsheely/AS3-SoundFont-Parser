package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /*
    struct sfSample
    {
        CHAR achSampleName[20];
        DWORD dwStart;
        DWORD dwEnd;
        DWORD dwStartloop;
        DWORD dwEndloop;
        DWORD dwSampleRate;
        BYTE byOriginalKey;
        CHAR chPitchCorrection;
        WORD wSampleLink;
        SFSampleLink sfSampleType;
    };
    */

    public class SampleRecord extends SFObject
    {
        public static const MONO:int = 0x1;
        public static const RIGHT:int = 0x2;
        public static const LEFT:int = 0x4;
        public static const ROM_MONO:int = 0x8001;
        public static const ROM_RIGHT:int = 0x8002;
        public static const ROM_LEFT:int = 0x8004;
        // Unsupported types:
        public static const LINKED:int = 0x8;
        public static const ROM_LINKED:int = 0x8008;

        public var id:int;
        public var name:String;
        public var start:uint;
        public var end:uint;
        public var loopStart:uint;
        public var loopEnd:uint;
        public var sampleRate:uint;
        public var originalPitch:int;
        public var pitchCorrection:int;
        public var sampleLink:int;
        public var bytes:SFByteArray;

        protected var _sampleType:int;

        public function SampleRecord()
        {
            super("SampleRecord");
            nonSerializedProperties.push("sampleData", "bytes");
        }

        public function get sampleType():int
        {
            return _sampleType;
        }

        public function set sampleType(value:int):void
        {
            if (value == LINKED || value == ROM_LINKED)
            {
                raiseError("Unsupported SampleType: " + value);
            }
            _sampleType = value;
        }

        public function get numChannels():int
        {
            return (this.sampleType == MONO || this.sampleType == ROM_MONO) ? 1 : 2;
        }

        public function get sampleData():ByteArray
        {
            var data:ByteArray = new ByteArray();
            data.endian = Endian.LITTLE_ENDIAN;
            data.writeBytes(this.bytes, this.start, this.end - this.start);
            data.position = 0;
            return data;
        }
    }
}
