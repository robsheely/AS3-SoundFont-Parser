/*The SHDR chunk is a required sub-chunk listing all samples within the smpl sub-chunk and any referenced ROM samples. 
It is always a multiple of forty-six bytes in length, and contains one record for each sample plus a terminal record 
according to the structure:
    struct sfSample 
    {
        CHAR achSampleName[20]; 
        DWORD dwStart; 
        DWORD dwEnd; 
        DWORD dwStartloop; 
        DWORD dwEndloop; 
        DWORD dwSampleRate; 
        BYTE byOriginalPitch; 
        CHAR chPitchCorrection; 
        WORD wSampleLink; 
        SFSampleLink sfSampleType;
    };
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.chunks.Subchunk;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class SamplesSubchunk extends Subchunk
    {
        public static const RECORD_SIZE:int = 46;

        public function SamplesSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("SamplesSubchunk", source, chunkSize, RECORD_SIZE);
        }

        public function getSampleRecord(index:int):SampleRecord
        {
            return getRecord(index) as SampleRecord;
        }

        public function set bytes(value:SFByteArray):void
        {
            for each (var record:SampleRecord in this.records)
            {
                record.bytes = value;
            }
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:SampleRecord = new SampleRecord();
            record.id = this.numRecords;
            record.name = bytes.readString(20);
            record.start = bytes.readDWord() * 2;
            record.end = bytes.readDWord() * 2;
            record.loopStart = bytes.readDWord() * 2;
            record.loopEnd = bytes.readDWord() * 2;
            record.sampleRate = bytes.readDWord();
            record.originalPitch = bytes.readUnsignedByte();
            record.pitchCorrection = bytes.readByte();
            record.sampleLink = bytes.readWord();
            record.sampleType = bytes.readWord();
            return record;
        }
    }
}
