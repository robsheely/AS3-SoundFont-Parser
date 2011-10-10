/* This is the frequency, in absolute cents, of the Vibrato LFO’s triangular period. A value of zero indicates
* a frequency of 8.176 Hz. A negative value indicates a frequency less than 8.176 Hz; a positive value a
* frequency greater than 8.176 Hz. For example, a frequency of 10 mHz would be 1200log2(.01/8.176) = -11610. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class FrequencyVibratoLFO extends ValueOperator
    {
        public function FrequencyVibratoLFO(amount:int = 0)
        {
            super(Operator.FREQ_VIB_LFO, amount);
        }
    }
}
