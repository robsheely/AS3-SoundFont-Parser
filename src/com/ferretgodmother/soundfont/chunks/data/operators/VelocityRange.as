/* This is the minimum and maximum MIDI velocity values for which this preset zone or instrument zone is active. The LS
 * byte indicates the highest and the MS byte the lowest valid velocity. The velRange enumerator is optional, but when
 * it does appear, it must be preceded only by keyRange in the zone generator list. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class VelocityRange extends RangeOperator
    {
        public function VelocityRange(values:Array)
        {
            super(Operator.VEL_RANGE, values);
        }
    }
}
