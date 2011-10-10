/* This is the time, in absolute timecents, from the end of the Volume Envelope Delay Time until the point at which the
 * Volume Envelope value reaches its peak. Note that the attack is “convex”; the curve is nominally such that when
 * applied to the decibel volume parameter, the result is linear in amplitude. A value of 0 indicates a 1 second attack
 * time. A negative value indicates a time less than one second; a positive value a time longer than one second. The
 * most negative number (- 32768) conventionally indicates instantaneous attack. For example, an attack time of 10 msec
 * would be 1200log2(.01) = -7973. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class AttackVolumeEnvelope extends ValueOperator
    {
        public function AttackVolumeEnvelope(amount:int = -12000)
        {
            super(Operator.ATTACK_RecordL_ENV, amount);
        }
    }
}
