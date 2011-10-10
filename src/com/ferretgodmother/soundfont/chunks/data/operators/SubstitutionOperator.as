/* Substitution Generators are generators which substitute a value for a note-on parameter. Two Substitution Generators
 * are currently defined, overridingKeyNumber and overridingVelocity. */
package com.ferretgodmother.soundfont.chunks.data.operators
{

    public class SubstitutionOperator extends Operator
    {
        public function SubstitutionOperator(type:int, amount:int = 0)
        {
            super(type, amount);
        }
    }
}
