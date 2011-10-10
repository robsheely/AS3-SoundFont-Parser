/* This is the degree, in cents, to which a full scale excursion of the Modulation Envelope will influence
* filter cutoff frequency. A positive number indicates an increase in cutoff frequency; a negative number
* indicates a decrease in filter cutoff frequency. Filter cutoff frequency is always modified logarithmically,
* that is the deviation is in cents, semitones, and octaves rather than in Hz. For example, a value of 1000
* indicates that the cutoff frequency will rise one octave at the envelope attack peak. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ModulationEnvelopeToFilterFC extends ValueOperator
    {
        public function ModulationEnvelopeToFilterFC(amount:int = 0)
        {
            super(Operator.MOD_ENV_TO_FILTER_FC, amount);
        }
    }
}
