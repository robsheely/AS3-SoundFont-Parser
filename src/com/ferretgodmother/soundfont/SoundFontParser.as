package com.ferretgodmother.soundfont
{
    import flash.utils.ByteArray;

    import com.ferretgodmother.soundfont.chunks.SoundFontChunk;
    import com.ferretgodmother.soundfont.utils.SFByteArray;

    public class SoundFontParser
    {
        public var soundFonts:Array = [ ];

        public function SoundFontParser()
        {
            //
        }

        public function parse(data:ByteArray):SoundFont
        {
            var bytes:SFByteArray = new SFByteArray(data);
            var soundFontChunk:SoundFontChunk = new SoundFontChunk(bytes);
            var soundFont:SoundFont = new SoundFont(soundFontChunk);
            soundFonts.push(soundFont);
            return soundFont;
        }
    }
}
