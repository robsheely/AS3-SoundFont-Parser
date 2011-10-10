package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.Subchunk;

    public class ModulatorsSubchunk extends Subchunk
    {
        public static const RECORD_SIZE:int = 10;

        public function ModulatorsSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("ModulatorsSubchunk", source, chunkSize, RECORD_SIZE);
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:ModulatorRecord = new ModulatorRecord();
            record.sourceOperator = bytes.readWord();
            record.destinationOperator = bytes.readWord();
            record.amountOperator = bytes.readShort();
            record.amountSourceOperator = bytes.readWord();
            record.transformOperator = bytes.readWord();
            return record;
        }
    }
}
