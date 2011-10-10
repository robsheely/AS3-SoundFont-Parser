/* This parameter represents the MIDI key number at which the sample is to be played back at its original
* sample rate. If not present, or if present with a value of -1, then the sample header parameter Original Key
* is used in its place. If it is present in the range 0-127, then the indicated key number will cause the
* sample to be played back at its sample header Sample Rate. For example, if the sample were a recording of a
* piano middle C (Original Key = 60) at a sample rate of 22.050 kHz, and Root Key were set to 69, then playing
* MIDI key number 69 (A above middle C) would cause a piano note of pitch middle C to be heard. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class OverridingRootKey extends SampleOperator
    {
        public function OverridingRootKey(amount:int = -1)
        {
            super(Operator.OVERRIDING_ROOT_KEY, amount);
        }
    }
}
