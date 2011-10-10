/* A Range Generator defines a range of note-on parameters outside of which the zone is undefined. Two Range Generators
 * are currently defined, keyRange and velRange. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.Range;

    public class RangeOperator extends Operator
    {
        public var high:int;

        public function RangeOperator(type:int, values:Array)
        {
            super(type, values[0]);
            this.high = values[1];
        }

        public function get low():int
        {
            return amount;
        }

        public function get values():Range
        {
            return new Range(this.type, this.low, this.high);
        }
    }
}
