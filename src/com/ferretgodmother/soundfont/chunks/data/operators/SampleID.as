/* This is the index into the SHDR sub-chunk providing the sample to be used for the current instrument zone. A value
 * of zero indicates the first sample in the list. The value should never exceed two less than the size of the sample
 * list. The sampleID enumerator is the terminal generator for IGEN zones. As such, it should only appear in the IGEN
 * subchunk, and it must appear as the last generator enumerator in all but the global zone. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class SampleID extends IndexOperator
    {
        public function SampleID(amount:int = 0)
        {
            super(Operator.SAMPLE_ID, amount);
        }
    }
}
