/*
    A data structure representing the low and high byte vlues of a ValueGenerator
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;

    public class Range extends SFObject
    {
        public var low:int;
        public var high:int;

        public function Range(type:String, low:int, high:int)
        {
            super(type);
            this.low = low;
            this.high = high;
        }
    }
}