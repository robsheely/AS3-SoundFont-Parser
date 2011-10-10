/* Unused, reserved. Should be ignored if encountered. */
package com.ferretgodmother.soundfont.chunks.data.operators
{

    public class UnusedOperator extends Operator
    {
        public function UnusedOperator(type:int, amount:int = 0)
        {
            super(type, amount);
        }

        override public function get isUnusedType():Boolean
        {
            return true;
        }
    }
}
