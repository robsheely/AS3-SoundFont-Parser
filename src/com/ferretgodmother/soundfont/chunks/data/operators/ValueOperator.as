/* Value Generators are generators whose value directly affects a signal processing parameter. Most generators are
 * value generators. */
package com.ferretgodmother.soundfont.chunks.data.operators
{

    public class ValueOperator extends Operator
    {
        public function ValueOperator(type:int, amount:int = 0)
        {
            super(type, amount);
        }
    }
}
