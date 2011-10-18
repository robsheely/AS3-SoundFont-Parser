/**
 * SoundFont represents the parsed and compiled contents of a SoundFont (sf2) file. It abstracts the SoundFont
 * structure to make it easier to access the elements you will usually want: the presets and instruments. You can
 * also use the getNoteSample function to access the sample data for a specified keyNum and velocity. The data
 * property contains the SoundFontChunk which provides access to the lower-level data of the file.
 */
package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.DataChunk;
    import com.ferretgodmother.soundfont.chunks.data.PresetRecord;
    import com.ferretgodmother.soundfont.chunks.SoundFontChunk;
    import com.ferretgodmother.soundfont.chunks.data.InstrumentRecord;
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;

    public class SoundFont extends SFObject
    {
        protected var _instruments:Array = [];
        protected var _presets:Array = [];
        protected var _selectedPreset:Preset;
        protected var _data:SoundFontChunk;

        public function SoundFont(data:SoundFontChunk)
        {
            super("SoundFont");
            nonSerializedProperties.push("data");
            this.data = data;
        }

        public function get selectedPreset():Preset
        {
            return _selectedPreset;
        }

        public function get presets():Array
        {
            return _presets.slice();
        }

        public function get instruments():Array
        {
            return _instruments.slice();
        }

        public function get data():SoundFontChunk
        {
            return _data;
        }

        public function set data(value:SoundFontChunk):void
        {
            _data = value;
            buildInstruments(_data.dataChunk);
            buildPresets(_data.dataChunk);
        }

        // Construct a NoteSample object for the given keyNum/velocity pair.
        public function getNoteSample(keyNum:int, velocity:int):NoteSample
        {
            var presetZone:PresetZone = getPresetZone(keyNum, velocity);
            if (presetZone != null)
            {
                var instrumentZone:InstrumentZone = presetZone.getInstrumentZone(keyNum, velocity);
                if (instrumentZone != null)
                {
                    var sample:SampleRecord = _data.getSampleRecord(instrumentZone.sampleID);
                    var noteSample:NoteSample = new NoteSample(sample, keyNum, velocity);
                    for each (var prop:String in NoteSample.PROPERTY_NAMES)
                    {
                        // Instrument generators replace the corresponding properties of the sample
                        noteSample[prop] = instrumentZone[prop];
                        // Preset generators are added to the corresponding properties of the sample + Instrument generator
                        if (presetZone.hasOwnProperty(prop))
                        {
                            noteSample[prop] += presetZone[prop];
                        }
                    }
                    return noteSample;
                }
            }
            return null;
        }

        public function getInstrumentZone(keyNum:int, velocity:int):InstrumentZone
        {
            var presetZone:PresetZone = getPresetZone(keyNum, velocity);
            return (presetZone != null) ? presetZone.getInstrumentZone(keyNum, velocity) : null;
        }

        public function getPresetZone(keyNum:int, velocity:int):PresetZone
        {
            return (selectedPreset != null) ? selectedPreset.getPresetZone(keyNum, velocity) : null;
        }

        public function selectPreset(presetID:int):void
        {
            _selectedPreset = getPreset(presetID);
        }

        public function getPreset(presetID:int):Preset
        {
            for each (var preset:Preset in _presets)
            {
                if (preset.presetID == presetID)
                {
                    return preset;
                }
            }
            return null;
        }

        public function buildInstruments(dataChunk:DataChunk):void
        {
            for each (var record:InstrumentRecord in dataChunk.instrumentRecords)
            {
                var instrument:Instrument = new Instrument(record);
                instrument.buildZones(dataChunk.sampleRecords);
                _instruments.push(instrument);
            }
        }

        public function buildPresets(dataChunk:DataChunk):void
        {
            for each (var record:PresetRecord in dataChunk.presetRecords)
            {
                var preset:Preset = new Preset(record);
                preset.buildZones(this.instruments);
                _presets.push(preset);
            }
        }
    }
}
