/* The offset, in 32768 sample data point increments beyond the Endloop sample header parameter to the sample data
 * point considered equivalent to the Startloop sample data point for the loop for this instrument. This parameter is
 * added to the endloopAddrsOffset parameter. For example, if Endloop were 5, endloopAddrsOffset were 3 and
 * endAddrsCoarseOffset were 2, sample data point 65544 would be considered equivalent to the Startloop sample data
 * point, and hence sample data point 65543 would effectively precede Startloop during looping. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class EndLoopAddressCoarseOffset extends SampleOperator
    {
        public function EndLoopAddressCoarseOffset(amount:int = 0)
        {
            super(Operator.END_LOOP_ADDRS_COARSE_OFFSET, amount);
        }
    }
}
