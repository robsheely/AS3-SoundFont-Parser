/* This is the delay time, in absolute timecents, between key on and the start of the attack phase of the Volume
 * envelope. A value of 0 indicates a 1 second delay. A negative value indicates a delay less than one second; a
 * positive value a delay longer than one second. The most negative number (-32768) conventionally indicates no delay.
 * For example, a delay of 10 msec would be 1200log2(.01) = -7973. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class DelayVolumeEnvelope extends ValueOperator
    {
        public function DelayVolumeEnvelope(amount:int = -12000)
        {
            super(Operator.DELAY_RecordL_ENV, amount);
        }
    }
}
