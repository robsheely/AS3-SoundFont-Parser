package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.Range;

    public class Zone extends SoundPropertyObject
    {
        public static const PROPERTY_NAMES:Array = [ ];

        private static const DEFAULTS:Object = { };

        // Ranges
        public var keyRange:Range = new Range("keyRange", 0, 127);
        public var velRange:Range = new Range("velocityRange", 0, 127);

        public function Zone(type:String)
        {
            super(type);
            if (PROPERTY_NAMES.length == 0)
            {
                initStaticConstants(PROPERTY_NAMES, DEFAULTS);
            }
        }

        public function fits(keyNum:int, velocity:int):Boolean
        {
            return keyNum >= this.keyRange.low && keyNum <= this.keyRange.high &&
                velocity >= this.velRange.low && velocity <= this.velRange.high;
        }

        override public function get propertyNames():Array
        {
            return PROPERTY_NAMES.slice();
        }

        override public function isDefault(prop:String):Boolean
        {
            if (prop == "keyRange" || prop == "velRange")
            {
                return DEFAULTS[prop].low == this[prop].low && DEFAULTS[prop].high == this[prop].high;
            }
            return super.isDefault(prop) || (PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop]);
        }
    }
}