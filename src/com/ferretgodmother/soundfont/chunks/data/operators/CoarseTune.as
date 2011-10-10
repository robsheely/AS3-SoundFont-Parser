/* This is a pitch offset, in semitones, which should be applied to the note. A positive value indicates the sound is
 * reproduced at a higher pitch; a negative value indicates a lower pitch. For example, a Coarse Tune value of -4 would
 * cause the sound to be reproduced four semitones flat. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class CoarseTune extends ValueOperator
    {
        public function CoarseTune(amount:int = 0)
        {
            super(Operator.COARSE_TUNE, amount);
        }
    }
}
