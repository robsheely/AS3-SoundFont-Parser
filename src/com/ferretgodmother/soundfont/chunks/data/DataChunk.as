/*
    The articulation data within a SoundFont 2 compatible file is contained in nine mandatory sub-chunks. This data
    is named “hydra” after the mythical nine-headed beast. The structure has been designed for interchange purposes;
    it is not optimized for either run-time synthesis or for on-the-fly editing. It is reasonable and proper for
    SoundFont compatible client programs to translate to and from the hydra structure as they read and write SoundFont
    compatible files.
*/
package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.chunks.Chunk;
    import com.ferretgodmother.soundfont.chunks.samples.SamplesChunk;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class DataChunk extends Chunk
    {
        public static const DATA_TAG:String = "pdta"
        public static const PRESET_TAG:String = "phdr";
        public static const PRESET_BAG_TAG:String = "pbag";
        public static const PRESET_MODULATOR_TAG:String = "pmod";
        public static const PRESET_GENERATOR_TAG:String = "pgen";
        public static const INSTRUMENT_TAG:String = "inst";
        public static const INSTRUMENT_BAG_TAG:String = "ibag";
        public static const INSTRUMENT_MODULATOR_TAG:String = "imod";
        public static const INSTRUMENT_GENERATOR_TAG:String = "igen";
        public static const SAMPLE_HEADER_TAG:String = "shdr";
        public static const END_OF_SAMPLES_TAG:String = "EOS";

        public var presetsSubchunk:PresetsSubchunk;
        public var presetBags:BagsSubchunk;
        public var presetModulators:ModulatorsSubchunk;
        public var presetGenerators:GeneratorsSubchunk;
        public var instrumentsSubchunk:InstrumentsSubchunk;
        public var instrumentBags:BagsSubchunk;
        public var instrumentModulators:ModulatorsSubchunk;
        public var instrumentGenerators:GeneratorsSubchunk;
        public var samplesSubchunk:SamplesSubchunk;

        public function DataChunk(source:SFByteArray = null)
        {
            super("DataChunk", source);
            this.nonSerializedProperties.push("numSamples");
        }

        public function get numSamples():Number
        {
            return sampleRecords.numRecords;
        }

        public function get presetRecords():Array
        {
            return presetsSubchunk.records;
        }

        public function get instrumentRecords():Array
        {
            return instrumentsSubchunk.records;
        }

        public function get sampleRecords():Array
        {
            return samplesSubchunk.records;
        }

        public function set sampleBytes(value:SamplesChunk):void
        {
            this.samplesSubchunk.bytes = value.bytes;
        }

        public function getSampleRecord(index:int):SampleRecord
        {
            return samplesSubchunk.getSampleRecord(index);
        }

        override public function parse(bytes:SFByteArray):void
        {
            while (bytes.bytesAvailable > 7)
            {
                _format = bytes.readString(4);
                _chunkSize = bytes.readDWord();
                switch (_format)
                {
                    case PRESET_TAG:
                    {
                        this.presetsSubchunk = new PresetsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case PRESET_BAG_TAG:
                    {
                        this.presetBags = new BagsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case PRESET_MODULATOR_TAG:
                    {
                        this.presetModulators = new ModulatorsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case PRESET_GENERATOR_TAG:
                    {
                        this.presetGenerators = new GeneratorsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case INSTRUMENT_TAG:
                    {
                        this.instrumentsSubchunk = new InstrumentsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case INSTRUMENT_BAG_TAG:
                    {
                        this.instrumentBags = new BagsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case INSTRUMENT_MODULATOR_TAG:
                    {
                        this.instrumentModulators = new ModulatorsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case INSTRUMENT_GENERATOR_TAG:
                    {
                        this.instrumentGenerators = new GeneratorsSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case SAMPLE_HEADER_TAG:
                    {
                        this.samplesSubchunk = new SamplesSubchunk(bytes, _chunkSize);
                        break;
                    }
                    case END_OF_SAMPLES_TAG:
                    default:
                    {
                        break;
                    }
                }
            }
            updateSamplesAndPresets();
        }

        protected function updateSamplesAndPresets():void
        {
            this.instrumentsSubchunk.processGenerators(this.instrumentGenerators, this.instrumentBags);
            this.presetsSubchunk.processGenerators(this.presetGenerators, this.presetBags);
        }
    }
}
