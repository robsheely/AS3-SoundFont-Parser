package com.ferretgodmother.soundfont.chunks.data
{
    /*
    struct sfInst
    {
        CHAR achInstName[20];
        WORD wInstBagNdx;
    };
    */

    public class InstrumentRecord extends ZoneRecord
    {
        public function InstrumentRecord()
        {
            super("InstrumentRecord");
        }
    }
}
