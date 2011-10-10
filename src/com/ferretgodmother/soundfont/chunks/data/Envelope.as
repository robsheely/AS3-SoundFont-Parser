package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;

    public class Envelope extends SFObject
    {
        public var delay:int = -12000;
        public var attack:int = -12000;
        public var hold:int = -12000;
        public var decay:int = -12000;
        public var sustain:int = 0;
        public var release:int = -12000;

        public function Envelope()
        {
            super("Envelope");
        }
    }
}