/**
 * SoundPropertyObject is the base class for Zone and NoteSample. It contains the properties that can be added to a
 * note or a zone by a generator. Another way to look at it is a SoundFontParser sound object consists of a sample
 * waveform and a series of properties that modify it. These properties are contained in the generator subchunks of
 * the data chunk.
 */
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

        // To keep the size of serialized the representation of SoundPropertyObjects to a minimum, only non-default
        // values are serialized.
        public function isDefault(prop:String):Boolean
        {
            return PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop];
        }

        // To keep the size of serialized the representation of SoundPropertyObjects to a minimum, only non-default
        // values are serialized.
        override protected function includePropertyInSerialization(propertyName:String):Boolean
        {
            return !isDefault(propertyName) && super.includePropertyInSerialization(propertyName);
        }

        // We could manually write out a constant that containes the default values of the propetties of this class.
        // Instead we let the class do it for us based on the initial values of the public properties defined above.
        // Nifty little hack, eh?
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
