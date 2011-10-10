/* The offset, in 32768 sample data point increments beyond the Startloop sample header parameter and the first sample
 * data point to be repeated in this instrument’s loop. This parameter is added to the startloopAddrsOffset parameter.
 * For example, if Startloop were 5, startloopAddrsOffset were 3 and startAddrsCoarseOffset were 2, the first sample
 * data point in the loop would be sample data point 65544. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class StartLoopAddressCoarseOffset extends SampleOperator
    {
        public function StartLoopAddressCoarseOffset(amount:int = 0)
        {
            super(Operator.START_LOOP_ADDRS_COARSE_OFFSET, amount);
        }
    }
}
