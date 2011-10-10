/* Sample Generators are generators which directly affect a sample’s properties. These generators are undefined at the
 * preset level. The currently defined Sample Generators are the eight address offset generators, the sampleModes
 * generator, the Overriding Root Key generator and the Exclusive Class generator. */
package com.ferretgodmother.soundfont.chunks.data.operators
{

    public class SampleOperator extends Operator
    {
        public function SampleOperator(type:int, amount:int = 0)
        {
            super(type, amount);
        }
    }
}
