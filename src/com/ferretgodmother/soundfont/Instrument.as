/**
 * Instrument represents the parsed and compiled contents of a SoundFont instrument element. It contains "zone"
 * definitions for determining which sample waveforms and dsp properties to use to create a specified keyNum abd
 * velocity. The data property contains the InstrumentRecord which represents the lower-level data for the
 * instrument (without any generators and modulators.)
 */
package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.InstrumentRecord;
    import com.ferretgodmother.soundfont.chunks.data.GeneratorRecord;
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.chunks.data.operators.RangeOperator;

    public class Instrument extends ZoneContainer
    {
        public function Instrument(record:InstrumentRecord)
        {
            super("Instrument", record, InstrumentZone);
        }

        /**
         * Finds a zone that can play the specifies key and velocity. If it can't find an exact match, it chooses the
         * closest non-match. KeyNum is the main determiner and velocity is the tie-breaker.
         */
        public function getInstrumentZone(keyNum:int, velocity:int):InstrumentZone
        {
            return getZone(keyNum, velocity) as InstrumentZone;
        }

        override protected function buildZone(generator:GeneratorRecord, records:Array):Zone
        {
            var zone:Zone = super.buildZone(generator, records);
            var sampleID:int = generator.sampleID;
            if (sampleID == -1)
            {
                _globalZone = zone;
            }
            else
            {
                InstrumentZone(zone).sample = records[sampleID];
                _zones.push(zone);
            }
            return zone;
        }
    }
}
