/*
    The sdta-list chunk in a SoundFont 2 compatible file contains a single optional smpl sub-chunk which contains
    all the RAM based sound data associated with the SoundFont compatible bank. The smpl sub- chunk is of arbitrary
    length, and contains an even number of bytes.

    The smpl sub-chunk, if present, contains one or more “samples” of digital audio information in the form of linearly
    coded sixteen bit, signed, little endian (least significant byte first) words. Each sample is followed by a minimum
    of forty-six zero valued sample data points. These zero valued data points are necessary to guarantee that any
    reasonable upward pitch shift using any reasonable interpolator can loop on zero data at the end of the sound.
*/
package com.ferretgodmother.soundfont.chunks.samples
{
    import com.ferretgodmother.soundfont.chunks.Chunk;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class SamplesChunk extends Chunk
    {
        public static const SAMPLE_TAG:String = "smpl";
        public static const SAMPLE_DATA_TAG:String = "sdta";
        public static const SAMPLE_24_TAG:String = "sm24";

        protected var _offset:uint = 0;
        protected var _bytes:SFByteArray;
        protected var _sample24Bytes:SFByteArray;

        public function SamplesChunk(source:SFByteArray = null)
        {
            super("SamplesChunk", source);
            this.nonSerializedProperties.push("length");
        }

        public function get offset():uint
        {
            return _offset;
        }

        public function get bytes():SFByteArray
        {
            return _bytes;
        }

        public function get length():uint
        {
            return _bytes.length;
        }

        override public function parse(value:SFByteArray):void
        {
            _format = value.readString(4);
            _chunkSize = value.readDWord();
            if (_format == SAMPLE_TAG)
            {
                _offset = value.position;
                _bytes = new SFByteArray();
                value.readBytes(_bytes, 0, _chunkSize);
            }
            else
            {
                trace("ERROR! Samples::set bytes: unrecognized type:", _format);
            }
        }
    }
}