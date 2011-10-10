/* This parameter represents the degree to which MIDI key number influences pitch. A value of zero indicates
* that MIDI key number has no effect on pitch; a value of 100 represents the usual tempered semitone scale. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ScaleTuning extends ValueOperator
    {
        public function ScaleTuning(amount:int = 100)
        {
            super(Operator.SCALE_TUNING, amount);
        }
    }
}
