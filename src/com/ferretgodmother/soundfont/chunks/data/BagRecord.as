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
