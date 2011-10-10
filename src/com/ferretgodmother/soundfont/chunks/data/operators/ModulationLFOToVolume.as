/* This is the degree, in centibels, to which a full scale excursion of the Modulation LFO will influence
* volume. A positive number indicates a positive LFO excursion increases volume; a negative number indicates a
* positive excursion decreases volume. Volume is always modified logarithmically, that is the deviation is in
* decibels rather than in linear amplitude. For example, a value of 100 indicates that the volume will first
* rise ten dB, then fall ten dB. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ModulationLFOToVolume extends ValueOperator
    {
        public function ModulationLFOToVolume(amount:int = 0)
        {
            super(Operator.MOD_LFO_TO_RecordLUME, amount);
        }
    }
}
