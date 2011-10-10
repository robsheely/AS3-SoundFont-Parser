/*
    The PBAG sub-chunk is a required sub-chunk listing all preset zones within the SoundFont compatible file. It is always
    a multiple of four bytes in length, and contains one record for each preset zone plus one record for a terminal zone
    according to the structure:
        struct sfPresetBag
        {
            WORD wGenNdx;
            WORD wModNdx;
        };
    The first zone in a given preset is located at that preset’s wPresetBagNdx. The number of zones in the preset is
    determined by the difference between the next preset’s wPresetBagNdx and the current wPresetBagNdx.

    The WORD wGenNdx is an index to the preset’s zone list of generators in the PGEN sub-chunk, and the wModNdx is an
    index to its list of modulators in the PMOD sub-chunk. Because both the generator and modulator lists are in the
    same order as the preset header and zone lists, these indices will be monotonically increasing with increasing preset
    zones. The size of the PMOD sub-chunk in bytes will be equal to ten times the terminal preset’s wModNdx plus ten and
    the size of the PGEN sub-chunk in bytes will be equal to four times the terminal preset’s wGenNdx plus four. If the
    generator or modulator indices are non-monotonic or do not match the size of the respective PGEN or PMOD sub-chunks,
    the file is structurally defective and should be rejected at load time.

    If a preset has more than one zone, the first zone may be a global zone. A global zone is determined by the fact that
    the last generator in the list is not an Instrument generator. All generator lists must contain at least one generator
    with one exception - if a global zone exists for which there are no generators but only modulators. The modulator
    lists can contain zero or more modulators.

    If a zone other than the first zone lacks an Instrument generator as its last generator, that zone should be ignored.
    A global zone with no modulators and no generators should also be ignored.

    If the PBAG sub-chunk is missing, or its size is not a multiple of four bytes, the file should be rejected as
    structurally unsound.

    The IBAG sub-chunk is a required sub-chunk listing all instrument zones within the SoundFont compatible file. It is
    always a multiple of four bytes in length, and contains one record for each instrument zone plus one record for
    a terminal zone according to the structure:
        struct sfInstBag
        {
            WORD wInstGenNdx;
            WORD wInstModNdx;
        };
    The first zone in a given instrument is located at that instrument’s wInstBagNdx. The number of zones in the instrument
    is determined by the difference between the next instrument’s wInstBagNdx and the current wInstBagNdx.

    The WORD wInstGenNdx is an index to the instrument zone’s list of generators in the IGEN sub-chunk, and the
    wInstModNdx is an index to its list of modulators in the IMOD sub-chunk. Because both the generator and modulator
    lists are in the same order as the instrument and zone lists, these indices will be monotonically increasing with
    increasing zones. The size of the IMOD sub-chunk in bytes will be equal to ten times the terminal instrument’s
    wModNdx plus ten and the size of the IGEN sub-chunk in bytes will be equal to four times the terminal instrument’s
    wGenNdx plus four. If the generator or modulator indices are non-monotonic or do not match the size of the respective
    IGEN or IMOD sub-chunks, the file is structurally defective and should be rejected at load time.

    If an instrument has more than one zone, the first zone may be a global zone. A global zone is determined by the fact
    that the last generator in the list is not a sampleID generator. All generator lists must contain at least one generator
    with one exception - if a global zone exists for which there are no generators but only modulators. The modulator lists
    can contain zero or more modulators.

    If a zone other than the first zone lacks a sampleID generator as its last generator, that zone should be ignored. A
    global zone with no modulators and no generators should also be ignored.

    If the IBAG sub-chunk is missing, or its size is not a multiple of four bytes, the file should be rejected as
    structurally unsound.
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.Subchunk;

    public class BagsSubchunk extends Subchunk
    {
        public static const RECORD_SIZE:int = 4;

        public function BagsSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("Bags", source, chunkSize, RECORD_SIZE);
        }

        public function getBag(index:int):BagRecord
        {
            return getRecord(index) as BagRecord;
        }

        public function get bags():Array
        {
            return this.records;
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:BagRecord = new BagRecord();
            record.generatorIndex = bytes.readWord();
            record.modulatorIndex = bytes.readWord();
            return record;
        }
    }
}
