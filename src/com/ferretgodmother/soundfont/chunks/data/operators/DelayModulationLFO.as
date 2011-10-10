/* This is the delay time, in absolute timecents, from key on until the Modulation LFO begins its upward ramp from zero
 * value. A value of 0 indicates a 1 second delay. A negative value indicates a delay less than one second and a
 * positive value a delay longer than one second. The most negative number (-32768) conventionally indicates no delay.
 * For example, a delay of 10 msec would be 1200log2(.01) = -7973. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class DelayModulationLFO extends ValueOperator
    {
        public function DelayModulationLFO(amount:int = -12000)
        {
            super(Operator.DELAY_MOD_LFO, amount);
        }
    }
}
