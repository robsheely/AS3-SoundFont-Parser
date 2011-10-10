/*
    A SoundFont 2 compatible RIFF file comprises three chunks: an INFO-list chunk containing a number of required and
    optional sub-chunks describing the file, its history, and its intended use, an sdta-list chunk comprising a single
    sub-chunk containing any referenced digital audio samples, and a pdta-list chunk containing nine sub-chunks which
    define the articulation of the digital audio data.
*/
package com.ferretgodmother.soundfont.chunks
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.data.DataChunk;
    import com.ferretgodmother.soundfont.chunks.info.InfoChunk;
    import com.ferretgodmother.soundfont.chunks.samples.SamplesChunk;
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;

    public class SoundFontChunk extends Chunk
    {
        public static const SOUND_FONT_BANK_TAG:String = "sfbk";

        public var infoChunk:InfoChunk;
        public var samplesChunk:SamplesChunk;
        public var dataChunk:DataChunk;

        public function SoundFontChunk(source:SFByteArray = null)
        {
            super("SoundFontChunk", source);
        }

        public function get presetRecords():Array
        {
            return dataChunk.presetRecords;
        }

        public function get instrumentRecords():Array
        {
            return dataChunk.instrumentRecords;
        }

        public function get sampleRecords():Array
        {
            return dataChunk.sampleRecords;
        }

        public function get numSamples():Number
        {
            return dataChunk.numSamples;
        }

        public function getSampleRecord(index:int):SampleRecord
        {
            return dataChunk.getSampleRecord(index);
        }

        override public function parse(bytes:SFByteArray):void
        {
            var format:String = bytes.readString(4);
            var chunkSize:uint = bytes.readDWord();
            if (format != Chunk.RIFF_TAG)
            {
                throw new Error("SoundFontParser::Incorrect format: " + format);
            }
            var type:String = bytes.readString(4);
            if (type != SoundFontChunk.SOUND_FONT_BANK_TAG)
            {
                throw new Error("SoundFontParser::Incorrect type: " + type);
            }
            while (bytes.bytesAvailable > 7)
            {
                format = bytes.readString(4);
                chunkSize = bytes.readDWord();
                if (format == Chunk.LIST_TAG)
                {
                    type = bytes.readString(4);
                    switch (type)
                    {
                        case InfoChunk.INFO_TAG:
                        {
                            this.infoChunk = new InfoChunk(bytes);
                            break;
                        }
                        case SamplesChunk.SAMPLE_DATA_TAG:
                        {
                            this.samplesChunk = new SamplesChunk(bytes);
                            break;
                        }
                        case DataChunk.DATA_TAG:
                        {
                            this.dataChunk = new DataChunk(bytes);
                            break;
                        }
                    }
                }
            }
            this.dataChunk.sampleBytes = this.samplesChunk;
        }
    }
}