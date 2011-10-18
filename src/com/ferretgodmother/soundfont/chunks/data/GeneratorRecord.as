/*
    A SoundFont Generator represents a list of operators that modify the properties of an InstrumentZone or a
    PresetZone. These operators are contained in the Instrument Generators subchunk and the Preset Generators subchunk.
    (Note: There is no "InstrumentGeneratorRecord" or "PresetGeneratorRecord" class, only the "GeneratorRecord" class
    which does double duty.)
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import flash.utils.Dictionary;

    import com.ferretgodmother.soundfont.SFObject;
    import com.ferretgodmother.soundfont.chunks.data.operators.KeyRange;
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.chunks.data.operators.RangeOperator;
    import com.ferretgodmother.soundfont.chunks.data.operators.SampleID;

    public class GeneratorRecord extends SFObject
    {
        public var operators:Dictionary = new Dictionary(false);

        public function GeneratorRecord()
        {
            super("Generator");
            this.nonSerializedProperties.push("operators");
        }

        public function setOperator(operator:Operator):void
        {
            this.operators[operator.id] = operator;
        }

        public function getOperator(type:int):Operator
        {
            return (this.operators.hasOwnProperty(type)) ? this.operators[type] : null;
        }

        public function get sampleID():int
        {
            if (this.operators.hasOwnProperty(Operator.SAMPLE_ID))
            {
                var operator:Operator = this.operators[Operator.SAMPLE_ID];
                return operator.amount;
            }
            return -1;
        }

        public function get instrumentID():int
        {
            if (this.operators.hasOwnProperty(Operator.INSTRUMENT))
            {
                var operator:Operator = this.operators[Operator.INSTRUMENT];
                return operator.amount;
            }
            return -1;
        }

        public function get keyRange():Range
        {
            if (this.operators.hasOwnProperty(Operator.KEY_RANGE))
            {
                var operator:RangeOperator = this.operators[Operator.KEY_RANGE];
                return operator.values;
            }
            return null;
        }

        public function get velocityRange():Range
        {
            if (this.operators.hasOwnProperty(Operator.VEL_RANGE))
            {
                var operator:RangeOperator = this.operators[Operator.VEL_RANGE];
                return operator.values;
            }
            return null;
        }
    }
}
