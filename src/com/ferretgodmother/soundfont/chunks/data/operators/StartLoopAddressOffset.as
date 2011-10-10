/* The offset, in sample data points, beyond the Startloop sample header parameter to the first sample data point to be
 * repeated in the loop for this instrument. For example, if Startloop were 10 and startloopAddrsOffset were -1, the
 * first repeated loop sample data point would be sample data point 9. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class StartLoopAddressOffset extends SampleOperator
    {
        public function StartLoopAddressOffset(amount:int = 0)
        {
            super(Operator.START_LOOP_ADDRS_OFFSET, amount);
        }
    }
}
