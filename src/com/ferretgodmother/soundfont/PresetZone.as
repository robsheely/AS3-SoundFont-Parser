/**
 * An PresetZone contains an Instrument property plus any generated properties that modify that Instrument.
 */
package com.ferretgodmother.soundfont
{
    public class PresetZone extends Zone
    {
        public static const PROPERTY_NAMES:Array = [];

        private static const DEFAULTS:Object = {};

        // The SoundFont specifications define the property name for the index of the instrument as "instrument."
        // To prevent confusion, we change that to "instrumentID" and let "instrument" refer to the instrument
        // object corresponding to that index.
        public var instrumentID:int = -1;
        public var instrument:Instrument;

        public function PresetZone()
        {
            super("PresetZone");
            if (PROPERTY_NAMES.length == 0)
            {
                initStaticConstants(PROPERTY_NAMES, DEFAULTS);
            }
        }

        /**
         * Finds a zone that can play the specified key and velocity. If it can't find an exact match, it chooses the
         * closest non-match. KeyNum is the main determiner and velocity is the tie-breaker.
         */
        public function getInstrumentZone(keyNum:int, velocity:int):InstrumentZone
        {
            return instrument.getInstrumentZone(keyNum, velocity);
        }

        override public function get propertyNames():Array
        {
            return PROPERTY_NAMES.slice();
        }

        override public function toXML():XML
        {
            var xml:XML = super.toXML();
            if (instrument != null)
            {
                xml.appendChild(instrument.toXML());
            }
            return xml;
        }

        override public function isDefault(prop:String):Boolean
        {
            return super.isDefault(prop) || (PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop]);
        }
    }
}
