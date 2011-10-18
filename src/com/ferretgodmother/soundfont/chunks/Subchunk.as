/*
    A RIFF file is constructed from a basic building block called a “chunk.”
    Two types of chunks, the “RIFF” and “LIST” chunks, may contain nested chunks called sub-chunks as their data.
*/

package com.ferretgodmother.soundfont.chunks
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class Subchunk extends Chunk
    {
        public var records:Array = [ ];

        protected var _recordSize:int = 1;

        public function Subchunk(type:String, source:SFByteArray, chunkSize:uint, recordSize:int)
        {
            _chunkSize = chunkSize;
            _recordSize = recordSize;
            super(type, source);
            this.nonSerializedProperties.push("records", "numRecords");
        }

        public function get numRecords():int
        {
            return records.length;
        }

        public function getRecord(index:int):Object
        {
            return (index > -1 && index < records.length) ? records[index] : null;
        }

        override public function parse(value:SFByteArray):void
        {
            var numOfRecords:int = _chunkSize / _recordSize - 1;
            for (var i:int = 0; i < numOfRecords; ++i)
            {
                var record:Object = createRecord(value);
                this.records.push(record);
            }
            // One "terminal" record needs to be read from the ByteArray. By calling createRecord() and ignoring
            // the returned object, we skip over the terminal record.
            createRecord(value);
        }

        protected function createRecord(bytes:SFByteArray):Object
        {
            // Abstract;
            return null;
        }
    }
}
