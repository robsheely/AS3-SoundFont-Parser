/* This is the time, in absolute timecents, from the end of the attack phase to the entry into decay phase, during
 * which the Volume envelope value is held at its peak. A value of 0 indicates a 1 second hold time. A negative value
 * indicates a time less than one second; a positive value a time longer than one second. The most negative number
 * (-32768) conventionally indicates no hold phase. For example, a hold time of 10 msec would be 1200log2(.01) = -7973.
 */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class HoldVolumeEnvelope extends ValueOperator
    {
        public function HoldVolumeEnvelope(amount:int = -12000)
        {
            super(Operator.HOLD_RecordL_ENV, amount);
        }
    }
}
