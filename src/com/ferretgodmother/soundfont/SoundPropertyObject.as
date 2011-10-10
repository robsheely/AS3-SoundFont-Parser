package com.ferretgodmother.soundfont
{
    public class SoundPropertyObject extends SFObject
    {
        public static const PROPERTY_NAMES:Array = [ ];

        private static const DEFAULTS:Object = { };

        // Tuning
        public var coarseTune:int = 0;
        public var fineTune:int = 0;
        public var scaleTuning:int = 100;
        // Envelopes
        public var delayVolEnv:int = -12000;
        public var attackVolEnv:int = -12000;
        public var holdVolEnv:int = -12000;
        public var decayVolEnv:int = -12000;
        public var sustainVolEnv:int = 0;
        public var releaseVolEnv:int = -12000;
        public var delayModEnv:int = -12000;
        public var attackModEnv:int = -12000;
        public var holdModEnv:int = -12000;
        public var decayModEnv:int = -12000;
        public var sustainModEnv:int = 0;
        public var releaseModEnv:int = -12000;
        // Keynum envelope modifications
        public var keyNumToModEnvHold:int = 0;
        public var keyNumToModEnvDecay:int = 0;
        public var keyNumToVolEnvHold:int = 0;
        public var keyNumToVolEnvDecay:int = 0;
        // Modulation envelope relation to pitch and filter
        public var modEnvToPitch:int = 0;
        public var modEnvToFilterFc:int = 0;
        // Low pass filter properties
        public var initialFilterFc:int = 13500;
        public var initialFilterQ:int = 0;
        // Effects
        public var pan:int = 0;
        public var initialAttenuation:int = 0;
        public var chorusEffectsSend:int = 0;
        public var reverbEffectsSend:int = 0;
        // LFOs (Low Frequency Modulators)
        public var delayModLFO:int = -12000;
        public var freqModLFO:int = 0;
        public var modLfoToPitch:int = 0;
        public var modLfoToFilterFc:int = 0;
        public var modLfoToVolume:int = 0;
        public var delayVibLFO:int = -12000;
        public var freqVibLFO:int = 0;
        public var vibLfoToPitch:int = 0;

        public function SoundPropertyObject(type:String)
        {
            super(type);
            if (PROPERTY_NAMES.length == 0)
            {
                initStaticConstants(PROPERTY_NAMES, DEFAULTS);
            }
        }

        override public function get propertyNames():Array
        {
            return PROPERTY_NAMES.slice();
        }

        public function isDefault(prop:String):Boolean
        {
            return PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop];
        }

        override protected function includePropertyInXML(propertyName:String):Boolean
        {
            return !isDefault(propertyName) && super.includePropertyInXML(propertyName);
        }

        protected function initStaticConstants(propertyNames:Array, defaults:Object):void
        {
            var props:Array = super.propertyNames.concat(getPropertyNames(false));
            for each (var prop:String in props)
            {
                propertyNames.push(prop);
                defaults[prop] = this[prop];
            }
        }
    }
}
