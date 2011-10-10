/**
 * Preset represents the parsed and compiled contents of a SoundFont preset element. It contains "zone" definitions
 * for determining which instrument element to use to create a specified keyNum abd velocity. The record property
 * contains the PresetRecord which represents the lower-level data for the instrument (without any generators and
 * modulators.)
 */
package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.PresetRecord;
    import com.ferretgodmother.soundfont.chunks.data.GeneratorRecord;
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.chunks.data.InstrumentsSubchunk;
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;
    import com.ferretgodmother.soundfont.chunks.data.operators.RangeOperator;

    public class Preset extends ZoneContainer
    {
        public function Preset(record:PresetRecord)
        {
            super("Preset", record, PresetZone);
        }

        public function get bank():int
        {
            return PresetRecord(this.record).bank;
        }

        public function get presetID():int
        {
            return PresetRecord(this.record).preset;
        }

        /**
         * Finds an instrument zone that matches the specifies key and velocity. If it can't find an exact match, it
         * chooses the closest non-match. KeyNum is the first priority and velocity is the tie-breaker. (This is
         * basically a convenience method to provide access to Instrument::getInstrumentZone without the hassle of
         * locating the proper preset zone first.)
         */
        public function getInstrumentZone(keyNum:int, velocity:int):InstrumentZone
        {
            var presetZone:PresetZone = getPresetZone(keyNum, velocity);
            return presetZone.getInstrumentZone(keyNum, velocity);
        }

        /**
         * Finds a preset zone that matches the specifies key and velocity. If it can't find an exact match, it chooses
         * the closest non-match. KeyNum is the first priority and velocity is the tie-breaker.
         */
        public function getPresetZone(keyNum:int, velocity:int):PresetZone
        {
            return getZone(keyNum, velocity) as PresetZone;
        }

        override public function toXML():XML
        {
            var xml:XML = super.toXML();
            xml.@bank = this.bank;
            xml.@presetID = this.presetID;
            return xml;
        }

        override protected function buildZone(generator:GeneratorRecord, records:Array):Zone
        {
            var zone:Zone = super.buildZone(generator, records);
            var instrumentID:int = generator.instrumentID;
            if (instrumentID == -1)
            {
                _globalZone = zone;
            }
            else
            {
                PresetZone(zone).instrument = records[instrumentID];
                _zones.push(zone);
            }
            return zone;
        }
    }
}
