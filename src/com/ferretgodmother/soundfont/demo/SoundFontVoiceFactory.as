package com.ferretgodmother.soundfont.demo
{
    import com.ferretgodmother.soundfont.SoundFont;

    import tonfall.core.TimeEventNote;
    import tonfall.prefab.poly.IPolySynthVoice;
    import tonfall.prefab.poly.IPolySynthVoiceFactory;

    public class SoundFontVoiceFactory implements IPolySynthVoiceFactory
    {
        protected var _soundFont:SoundFont;
        protected var _lastID:int = -1;

        public function SoundFontVoiceFactory(soundFont:SoundFont)
        {
            _soundFont = soundFont;
        }

        public function create(event:TimeEventNote):IPolySynthVoice
        {
            var voice:SoundFontVoice = new SoundFontVoice(_soundFont, ++_lastID);
            return voice;
        }
    }
}
