/* This is the degree, in cents, to which a full scale excursion of the Vibrato LFO will influence pitch. A positive
 * value indicates a positive LFO excursion increases pitch; a negative value indicates a positive excursion decreases
 * pitch. Pitch is always modified logarithmically, that is the deviation is in cents, semitones, and octaves rather
 * than in Hz. For example, a value of 100 indicates that the pitch will first rise 1 semitone, then fall one semitone.
 */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class VibratoLFOToPitch extends ValueOperator
    {
        public function VibratoLFOToPitch(amount:int = 0)
        {
            super(Operator.VIB_LFO_TO_PITCH, amount);
        }
    }
}
