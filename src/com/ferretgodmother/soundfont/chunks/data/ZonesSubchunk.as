package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.Subchunk;

    public class ZonesSubchunk extends Subchunk
    {
        public function ZonesSubchunk(type:String, source:SFByteArray, chunkSize:uint, recordSize:int)
        {
            super(type, source, chunkSize, recordSize);
        }

        public function getZoneRecord(index:int):ZoneRecord
        {
            return getRecord(index) as ZoneRecord;
        }

        public function processGenerators(generators:GeneratorsSubchunk, bags:BagsSubchunk):void
        {
            var numBags:int = bags.numRecords;
            var numOperators:int = generators.numRecords;
            for (var i:int = 0; i < this.numRecords; i++)
            {
                var record:ZoneRecord = getZoneRecord(i);
                var nextRecord:ZoneRecord = (i < this.numRecords - 1) ? getZoneRecord(i + 1) : null;
                var generatorStart:int = record.index;
                var generatorEnd:int = (nextRecord != null) ? nextRecord.index : numBags;
                for (var j:int = generatorStart; j < generatorEnd; j++)
                {
                    var generator:GeneratorRecord = new GeneratorRecord();
                    var bag:BagRecord = bags.getBag(j);
                    var nextBag:BagRecord = (j < numBags - 1) ? bags.getBag(j + 1) : null;
                    var operatorStart:int = bag.generatorIndex;
                    var operatorEnd:int = (nextBag != null) ? nextBag.generatorIndex : numOperators;
                    var numUsedOperators:int = 0;
                    for (var k:int = operatorStart; k < operatorEnd; k++)
                    {
                        var operator:Operator = generators.getOperator(k);
                        // We ignore any unused operator types
                        if (!operator.isUnusedType)
                        {
                            generator.operators[operator.id] = operator;
                            ++numUsedOperators;
                        }
                    }
                    // If all the operators for this generator are unused types, we don't want to
                    // add it to our preset
                    if (numUsedOperators > 0)
                    {
                        record.addGenerator(generator);
                    }
                }
            }
        }
    }
}
