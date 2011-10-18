/**
 * An InstrumentZone contains a Sample property plus any generated properties that modify that Sample.
 */
package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;

    public class InstrumentZone extends Zone
    {
        public static const PROPERTY_NAMES:Array = [ ];

        private static const DEFAULTS:Object = { };

        public var sampleID:int = -1;
        public var sample:SampleRecord;
        // Tuning
        public var overridingRootKey:int = -1;
        public var velocity:int = -1;
        public var keyNum:int = -1;
        // Sample offsets
        public var startAddrsOffset:int = 0;
        public var endAddrsOffset:int = 0;
        public var startLoopAddrsOffset:int = 0;
        public var endLoopAddrsOffset:int = 0;
        public var startAddrsCoarseOffset:int = 0;
        public var endAddrsCoarseOffset:int = 0;
        public var startLoopAddrsCoarseOffset:int = 0;
        public var endLoopAddrsCoarseOffset:int = 0;
        // Sample mode & link
        public var sampleMode:int = 0;
        public var sampleLink:int = 0;
        // In a category by inself
        public var exclusiveClass:int = 0

        public function InstrumentZone()
        {
            super("InstrumentZone");
            if (PROPERTY_NAMES.length == 0)
            {
                initStaticConstants(PROPERTY_NAMES, DEFAULTS);
            }
        }

        override public function get propertyNames():Array
        {
            return PROPERTY_NAMES.slice();
        }

        override public function isDefault(prop:String):Boolean
        {
            return super.isDefault(prop) || (PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop]);
        }
    }
}
