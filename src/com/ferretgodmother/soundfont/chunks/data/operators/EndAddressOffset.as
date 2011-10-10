/* The offset, in sample sample data points, beyond the End sample header parameter to the last sample data point to be
 * played for this instrument. For example, if End were 17 and endAddrOffset were -2, the last sample data point played
 * would be sample data point 15.
 *
 * Unit: samples
 * Abs Zero: 0
 * Min: Depends on values of start, loop, & end points in sample header
 * Min Useful: Depends on values of start, loop, & end points in sample header
 * Max: 0
 * Max Useful: None
 * Default: 0 (None)
 */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class EndAddressOffset extends SampleOperator
    {
        public function EndAddressOffset(amount:int = 0)
        {
            super(Operator.END_ADDRS_OFFSET, amount);
        }
    }
}
