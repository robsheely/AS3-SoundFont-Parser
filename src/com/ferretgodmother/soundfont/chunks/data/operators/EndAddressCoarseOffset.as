/* The offset, in 32768 sample data point increments beyond the End sample header parameter and the last sample
* data point to be played in this instrument. This parameter is added to the endAddrsOffset parameter. For
* example, if End were 65536, startAddrsOffset were -3 and startAddrsCoarseOffset were -1, the last sample
* data point played would be sample data point 32765. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class EndAddressCoarseOffset extends SampleOperator
    {
        public function EndAddressCoarseOffset(amount:int = 0)
        {
            super(Operator.END_ADDRS_COARSE_OFFSET, amount);
        }
    }
}
