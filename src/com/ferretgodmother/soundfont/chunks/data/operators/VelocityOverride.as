/* This enumerator forces the MIDI velocity to effectively be interpreted as the value given. This generator can only
 * appear at the instrument level. Valid values are from 0 to 127. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class VelocityOverride extends SubstitutionOperator
    {
        public function VelocityOverride(amount:int = -1)
        {
            super(Operator.VELOCITY, amount);
        }
    }
}
