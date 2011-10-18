/*
    The PGEN chunk is a required chunk containing a list of preset zone generators for each preset zone within the
    SoundFont compatible file. It is always a multiple of four bytes in length, and contains one or more generators
    for each preset zone (except a global zone containing only modulators) plus a terminal record according to the
        structure:
        struct sfGenList
        {
            SFGenerator sfGenOper;
            genAmountType genAmount;
        };
        where the types are defined:
        typedef struct
        {
            BYTE byLo;
            BYTE byHi;
        }
        rangesType;
        typedef union
        {
            rangesType ranges;
            SHORT shAmount;
            WORD wAmount;
        }
        genAmountType;
    The sfGenOper is a value of one of the SFGenerator enumeration type values. Unknown or undefined values are ignored.
    This value indicates the type of generator being indicated. Note that this enumeration is two bytes in length.
    The genAmount is the value to be assigned to the specified generator. Note that this can be of three formats.
    Certain generators specify a range of MIDI key numbers of MIDI velocities, with a minimumand maximum value.
    Other generators specify an unsigned WORD value. Most generators, however, specify a signed 16 bit SHORT value.

    The preset zone’s wGenNdx points to the first generator for that preset zone. Unless the zone is a global zone,
    the last generator in the list is an “Instrument” generator, whose value is a pointer to the instrument associated
    with that zone. If a “key range” generator exists for the preset zone, it is always the first generator in the list
    for that preset zone. If a “velocity range” generator exists for the preset zone, it will only be preceded by a key
    range generator. If any generators follow an Instrument generator, they will be ignored.

    A generator is defined by its sfGenOper. All generators within a zone must have a unique sfGenOper
    enumerator. If a second generator is encountered with the same sfGenOper enumerator as a previous generator with
    the same zone, the first generator will be ignored.

    Generators in the PGEN sub-chunk are applied relative to generators in the IGEN sub-chunk in an
    additive manner. In other words, PGEN generators increase or decrease the value of an IGEN generator.
    Section “9.4 The SoundFont Generator Model” contains the details of how this application works.

    If the PGEN sub-chunk is missing, or its size is not a multiple of four bytes, the file should be
    rejected as structurally unsound. If a key range generator is present and not the first generator, it should be
    ignored. If a velocity range generator is present, and is preceded by a generator other than a key range
    generator, it should be ignored. If a non-global list does not end in an instrument generator, zone should be
    ignored. If the instrument generator value is equal to or greater than the terminal instrument, the file
    should be rejected as structurally unsound.

    The IGEN chunk is a required chunk containing a list of zone generators for each instrument zone within the
    SoundFont compatible file. It is always a multiple of four bytes in length, and contains one or more generators
    for each zone (except for a global zone containing only modulators) plus a terminal record according to the
    structure:
        struct sfInstGenList
        {
            SFGenerator sfGenOper;
            genAmountType genAmount;
        };
    where the types are defined as in the PGEN zone above.

    The genAmount is the value to be assigned to the specified generator. Note that this can be of three formats.
    Certain generators specify a range of MIDI key numbers of MIDI velocities, with a minimum and maximum value.
    Other generators specify an unsigned WORD value. Most generators, however, specify a signed 16 bit SHORT value.
    The zone’s wInstGenNdx points to the first generator for that zone. Unless the zone is a global zone, the last
    generator in the list is a “sampleID” generator, whose value is a pointer to the sample associated with that zone.
    If a “key range” generator exists for the zone, it is always the first generator in the list for that zone.
    If a “velocity range” generator exists for the zone, it will only be preceded by a key range generator. If any
    generators follow a sampleID generator, they will be ignored.

    A generator is defined by its sfGenOper. All generators within a zone must have a unique sfGenOper enumerator.
    If a second generator is encountered with the same sfGenOper enumerator as a previous generator within the same
    zone, the first generator will be ignored.

    Generators in the IGEN sub-chunk are absolute in nature. This means that an IGEN generator replaces, rather
    than adds to, the default value for the generator.

    If the IGEN sub-chunk is missing, or its size is not a multiple of four bytes, the file should be rejected
    as structurally unsound. If a key range generator is present and not the first generator, it should be ignored.
    If a velocity range generator is present, and is preceded by a generator other than a key range generator, it
    should be ignored. If a non-global list does not end in a sampleID generator, the zone should be ignored. If
    the sampleID generator value is equal to or greater than the terminal sampleID, the file should be rejected as
    structurally unsound.

    (Note: The properties of these two classes are identical so there is no "InstrumentGeneratorsSubchunk" or
    "PresetGeneratorsSubchunk" class, only the "GeneratorsSubchunk" class which is instantiated twice: once for the
    Instrument Generators subchunk and once for the Preset Generators subchunk.)
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.chunks.Subchunk;
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.chunks.data.operators.OperatorFactory;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class GeneratorsSubchunk extends Subchunk
    {
        public static const RECORD_SIZE:int = 4;

        public function GeneratorsSubchunk(source:SFByteArray, chunkSize:uint)
        {
            super("GeneratorsSubchunk", source, chunkSize, RECORD_SIZE);
        }

        public function getOperator(index:int):Operator
        {
            return getRecord(index) as Operator;
        }

        override protected function createRecord(bytes:SFByteArray):Object
        {
            var record:Operator = OperatorFactory.create(bytes);
            return record;
        }
    }
}
