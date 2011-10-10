/* This is the time, in absolute timecents, for a 100% change in the Modulation Envelope value during release phase.
 * For the Modulation Envelope, the release phase linearly ramps toward zero from the current level. If the current
 * level were full scale, the Modulation Envelope Release Time would be the time spent in release phase until zero
 * value were reached. A value of 0 indicates a 1 second decay time for a release from full level. A negative value
 * indicates a time less than one second; a positive value a time longer than one second. For example, a release time
 * of 10 msec would be 1200log2(.01) = -7973. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class ReleaseModulationEnvelope extends ValueOperator
    {
        public function ReleaseModulationEnvelope(amount:int = -12000)
        {
            super(Operator.RELEASE_MOD_ENV, amount);
        }
    }
}
