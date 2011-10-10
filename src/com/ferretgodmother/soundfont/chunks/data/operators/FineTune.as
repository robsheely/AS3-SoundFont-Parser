/* This is a pitch offset, in cents, which should be applied to the note. It is additive with coarseTune. A
* positive value indicates the sound is reproduced at a higher pitch; a negative value indicates a lower
* pitch. For example, a Fine Tuning value of -5 would cause the sound to be reproduced five cents flat. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class FineTune extends ValueOperator
    {
        public function FineTune(amount:int = 0)
        {
            super(Operator.FINE_TUNE, amount);
        }
    }
}
