/* An Index Generator’s amount is an index into another data structure. The only two Index Generators are Instrument
 * and sampleID. */
package com.ferretgodmother.soundfont.chunks.data.operators
{

    public class IndexOperator extends Operator
    {
        public function IndexOperator(type:int, amount:int = 0)
        {
            super(type, amount);
        }
    }
}
