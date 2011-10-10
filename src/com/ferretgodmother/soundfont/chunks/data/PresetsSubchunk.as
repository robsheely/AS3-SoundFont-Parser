/*
    The PHDR sub-chunk is a required sub-chunk listing all presets within the SoundFont compatible file. It is always
    a multiple of thirty-eight bytes in length, and contains a minimum of two records, one record for each preset and
    one for a terminal record.

    The terminal sfPresetHeader record should never be accessed, and exists only to provide a terminal wPresetBagNdx
    with which to determine the number of zones in the last preset. All other values are conventionally zero, with
    the exception of achPresetName, which can optionally be “EOP” indicating end of presets.

    If the PHDR sub-chunk is missing, or contains fewer than two records, or its size is not a multiple of 38 bytes,
    the file should be rejected as structurally unsound.
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class PresetsSubchunk extends ZonesSubchunk
    {
        public static const END_OF_PRESETS_TAG:String = "EOP";
        public static const RECORD_SIZE:int = 38;

        public function PresetsSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("PresetsSubchunk", source, chunkSize, RECORD_SIZE);
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:PresetRecord = new PresetRecord();
            record.id = this.numRecords;
            record.name = bytes.readString(20);
            record.preset = bytes.readWord();
            record.bank = bytes.readWord();
            record.index = bytes.readWord();
            record.library = bytes.readDWord();
            record.genre = bytes.readDWord();
            record.morphology = bytes.readDWord();
            return record;
        }
    }
}
