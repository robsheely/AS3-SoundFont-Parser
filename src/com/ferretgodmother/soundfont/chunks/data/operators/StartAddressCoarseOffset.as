/* The offset, in 32768 sample data point increments beyond the Start sample header parameter and the first sample data
 * point to be played in this instrument. This parameter is added to the startAddrsOffset parameter. For example, if
 * Start were 5, startAddrsOffset were 3 and startAddrsCoarseOffset were 2, the first sample data point played would be
 * sample data point 65544. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class StartAddressCoarseOffset extends SampleOperator
    {
        public function StartAddressCoarseOffset(amount:int = 0)
        {
            super(Operator.START_ADDRS_COARSE_OFFSET, amount);
        }
    }
}
