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

        /* A "bag" is a subchunk that contains an arbitrary number of data records. Each record in the bag contains a
        generator index and a modulator index. The generator index represents the index of the first generator operator
        that belongs to the InstrumentZone or PresetZone associated with the bag record. By navigating through the
        given generators subchunk we construct Generators and Operators, assigning the Operators to the appropriate
        Generator and the Genrators to the appropriate Zone. */
        public function processGenerators(generators:GeneratorsSubchunk, bags:BagsSubchunk):void
        {
            var numBags:int = bags.numRecords;
            var numOperators:int = generators.numRecords;
            for (var i:int = 0; i < this.numRecords; i++)
            {
                var record:ZoneRecord = getZoneRecord(i);
                var nextRecord:ZoneRecord = (i < this.numRecords - 1) ? getZoneRecord(i + 1) : null;
                var generatorStart:int = record.index;
                // The index of last generator of the current ZoneRecord is one less than the index of the first
                // generator of the next ZoneRecord -- unless this is the last ZoneRecord. In that case, the index of
                // the last generator is one less than the total number of records contained in the bags subchunk.
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
