/*
    The inst sub-chunk is a required sub-chunk listing all instruments within the SoundFont compatible file. It is
    always a multiple of twenty-two bytes in length, and contains a minimum of two records, one record for each
    instrument and one for a terminal record according to the structure:
        struct sfInst
        {
            CHAR achInstName[20];
            WORD wInstBagNdx;
        };
    The ASCII character field achInstName contains the name of the instrument expressed in ASCII, with unused
    terminal characters filled with zero valued bytes. Instrument names are case-sensitive. A unique name should
    always be assigned to each instrument in the SoundFont compatible bank to enable identification. However, if
    a bank is read containing the erroneous state of instruments with identical names, the instruments should not
    be discarded. They should either be preserved as read or preferably uniquely renamed.
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class InstrumentsSubchunk extends ZonesSubchunk
    {
        public static const END_OF_INSTRUMENTS_TAG:String = "EOI";
        public static const RECORD_SIZE:int = 22;

        public function InstrumentsSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("InstrumentsSubchunk", source, chunkSize, RECORD_SIZE);
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:InstrumentRecord = new InstrumentRecord();
            record.id = records.length;
            record.name = bytes.readString(20);
            record.index = bytes.readWord();
            return record;
        }
    }
}
