/* This is the degree, in 0.1% units, to which the audio output of the note is sent to the chorus effects
* processor. A value of 0% or less indicates no signal is sent from this note; a value of 100% or more
* indicates the note is sent at full level. Note that this parameter has no effect on the amount of this
* signal sent to the “dry” or unprocessed portion of the output. For example, a value of 250 indicates that
* the signal is sent at 25% of full level (attenuation of 12 dB from full level) to the chorus effects
* processor. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ChorusEffectsSend extends ValueOperator
    {
        public function ChorusEffectsSend(amount:int = 0)
        {
            super(Operator.CHORUS_EFFECTS_SEND, amount);
        }
    }
}
