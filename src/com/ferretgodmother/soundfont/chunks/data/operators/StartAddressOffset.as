/* The offset, in sample data points, beyond the Start sample header parameter to the first sample data point to be
 * played for this instrument. For example, if Start were 7 and startAddrOffset were 2, the first sample data point
 * played would be sample data point 9.
 *
 * Unit: samples
 * Abs Zero: 0
 * Min: 0
 * Min Useful: None
 * Max: Depends on values of start, loop, & end points in sample header
 * Max Useful: Depends on values of start, loop, & end points in sample header
 * Default: 0 (None)
 */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class StartAddressOffset extends SampleOperator
    {
        public function StartAddressOffset(amount:int = 0)
        {
            super(Operator.START_ADDRS_OFFSET, amount);
        }
    }
}
