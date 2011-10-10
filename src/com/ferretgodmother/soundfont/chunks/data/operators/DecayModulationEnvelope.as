/* This is the time, in absolute timecents, for a 100% change in the Modulation Envelope value during decay phase. For
 * the Modulation Envelope, the decay phase linearly ramps toward the sustain level. If the sustain level were zero,
 * the Modulation Envelope Decay Time would be the time spent in decay phase. A value of 0 indicates a 1 second decay
 * time for a zero-sustain level. A negative value indicates a time less than one second; a positive value a time
 * longer than one second. For example, a decay time of 10 msec would be 1200log2(.01) = -7973. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class DecayModulationEnvelope extends ValueOperator
    {
        public function DecayModulationEnvelope(amount:int = -12000)
        {
            super(Operator.DECAY_MOD_ENV, amount);
        }
    }
}
