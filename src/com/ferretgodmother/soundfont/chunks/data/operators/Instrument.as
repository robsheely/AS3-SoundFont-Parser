/* This is the index into the INST sub-chunk providing the instrument to be used for the current preset zone. A value
 * of zero indicates the first instrument in the list. The value should never exceed two less than the size of the
 * instrument list. The instrument enumerator is the terminal generator for PGEN zones. As such, it should only appear
 * in the PGEN sub-chunk, and it must appear as the last generator enumerator in all but the global preset zone. */
package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class Instrument extends IndexOperator
    {
        public function Instrument(amount:int = 0)
        {
            super(Operator.INSTRUMENT, amount);
        }
    }
}
