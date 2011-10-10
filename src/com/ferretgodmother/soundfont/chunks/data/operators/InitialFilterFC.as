/* This is the cutoff and resonant frequency of the lowpass filter in absolute cent units. The lowpass filter
* is defined as a second order resonant pole pair whose pole frequency in Hz is defined by the Initial Filter
* Cutoff parameter. When the cutoff frequency exceeds 20kHz and the Q (resonance) of the filter is zero, the
* filter does not affect the signal. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class InitialFilterFC extends ValueOperator
    {
        public function InitialFilterFC(amount:int = 13500)
        {
            super(Operator.INITIAL_FILTER_FC, amount);
        }
    }
}
