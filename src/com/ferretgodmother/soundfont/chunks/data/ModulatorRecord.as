package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;

    /*
    struct sfModList
    {
        SFModulator sfModSrcOper;
        SFGenerator sfModDestOper;
        SHORT modAmount;
        SFModulator sfModAmtSrcOper;
        SFTransform sfModTransOper;
    };
    */

    public class ModulatorRecord extends SFObject
    {
        public var sourceOperator:int;
        public var destinationOperator:int;
        public var amountOperator:int;
        public var amountSourceOperator:int;
        public var transformOperator:int;

        public function ModulatorRecord()
        {
            super("Modulator");
        }
    }
}
