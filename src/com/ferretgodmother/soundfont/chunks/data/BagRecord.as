/*
    A "bag" is a subchunk that contains an arbitrary number of data records. Each record in the bag contains a
    generator index and a modulator index. The generator index represents the index of the first generator operator
    that belongs to the InstrumentZone or PresetZone associated with the bag record. The modulator index represents the
    first modulator operator that belongs to the InstrumentZone or PresetZone associated with the bag record.

    It can be a tricky concept to grasp. Look at the processGenerator() function of the ZonesSubchunk class to see
    how the generator and modulator operators are assigned to the appropriate zone.
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;
    /*
    struct sfPresetBag
    {
        WORD wGenNdx;
        WORD wModNdx;
    };
    */
    public class BagRecord extends SFObject
    {
        public var generatorIndex:int;
        public var modulatorIndex:int;

        public function BagRecord()
        {
            super("Bag");
        }
    }
}
