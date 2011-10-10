/* This is the minimum and maximum MIDI key number values for which this preset zone or instrument zone is active. The
 * LS byte indicates the highest and the MS byte the lowest valid key. The keyRange enumerator is optional, but when it
 * does appear, it must be the first generator in the zone generator list. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class KeyRange extends RangeOperator
    {
        public function KeyRange(values:Array)
        {
            super(Operator.KEY_RANGE, values);
        }
    }
}
