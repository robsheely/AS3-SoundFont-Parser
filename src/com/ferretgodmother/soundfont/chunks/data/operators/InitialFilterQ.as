/* This is the height above DC gain in centibels which the filter resonance exhibits at the cutoff frequency. A
* value of zero or less indicates the filter is not resonant; the gain at the cutoff frequency (pole angle)
* may be less than zero when zero is specified. The filter gain at DC is also affected by this parameter such
* that the gain at DC is reduced by half the specified gain. For example, for a value of 100, the filter gain
* at DC would be 5 dB below unity gain, and the height of the resonant peak would be 10 dB above the DC gain,
* or 5 dB above unity gain. Note also that if initialFilterQ is set to zero or less and the cutoff frequency
* exceeds 20 kHz, then the filter response is flat and unity gain. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class InitialFilterQ extends ValueOperator
    {
        public function InitialFilterQ(amount:int = 0)
        {
            super(Operator.INITIAL_FILTER_Q, amount);
        }
    }
}
