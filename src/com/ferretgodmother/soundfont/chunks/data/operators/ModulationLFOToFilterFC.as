/* This is the degree, in cents, to which a full scale excursion of the Modulation LFO will influence filter
* cutoff frequency. A positive number indicates a positive LFO excursion increases cutoff frequency; a
* negative number indicates a positive excursion decreases cutoff frequency. Filter cutoff frequency is always
* modified logarithmically, that is the deviation is in cents, semitones, and octaves rather than in Hz. For
* example, a value of 1200 indicates that the cutoff frequency will first rise 1 octave, then fall one octave.
*/
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ModulationLFOToFilterFC extends ValueOperator
    {
        public function ModulationLFOToFilterFC(amount:int = 0)
        {
            super(Operator.MOD_LFO_TO_FILTER_FC, amount);
        }
    }
}
