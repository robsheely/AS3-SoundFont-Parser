/* This is the attenuation, in centibels, by which a note is attenuated below full scale. A value of zero indicates no
 * attenuation; the note will be played at full scale. For example, a value of 60 indicates the note will be played at
 * 6 dB below full scale for the note. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class InitialAttenuation extends ValueOperator
    {
        public function InitialAttenuation(amount:int = 0)
        {
            super(Operator.INITIAL_ATTENUATION, amount);
        }
    }
}
