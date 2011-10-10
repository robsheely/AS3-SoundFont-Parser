package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;

    import flash.utils.ByteArray;

    public class NoteSample extends SoundPropertyObject
    {
        public static const PROPERTY_NAMES:Array = [];

        private static const DEFAULTS:Object = {};

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

        public var sample:SampleRecord;

        public function NoteSample(sample:SampleRecord, keyNum:int, velocity:int)
        {
            super("NoteSample");
            if (PROPERTY_NAMES.length == 0)
            {
                initStaticConstants(PROPERTY_NAMES, DEFAULTS);
            }
            this.sample = sample;
            this.keyNum = keyNum;
            this.velocity = velocity;
        }

        public function get sampleData():ByteArray
        {
            return sample.sampleData;
        }

        override public function isDefault(prop:String):Boolean
        {
            return PROPERTY_NAMES.indexOf(prop) != -1 && DEFAULTS[prop] == this[prop];
        }

        public function getTransposition(keyNum:int):Number
        {
            return noteToFrequency(keyNum) / this.rootFrequency;
        }

        /**
         * Note: note can contain a fractional portion. That way any cents-based adjustments can be added to the base midi
         * note int value
         */
        public function noteToFrequency(note:Number = 60):Number
        {
            return 440 * Math.pow(2.0, (note - 69) / 12);
        }

        public function get rootKey():int
        {
            return (isDefault("overridingRootKey")) ? this.sample.originalPitch : this.overridingRootKey;
        }

        public function get rootFrequency():Number
        {
            return noteToFrequency(this.rootKey + sample.pitchCorrection * 0.1 + this.coarseTune + this.fineTune * 0.01);
        }

        public function get length():uint
        {
            return this.end - this.start;
        }

        public function get start():uint
        {
            return this.sample.start + this.startAddrsCoarseOffset * 32768 + this.startAddrsOffset;
        }

        public function get end():uint
        {
            return this.sample.end + this.endAddrsCoarseOffset * 32768 + this.endAddrsOffset;
        }

        public function get numChannels():int
        {
            return this.sample.numChannels;
        }

        public function get linkedSampleIndex():int
        {
            return (this.numChannels == 2) ? this.sample.sampleLink : -1;
        }

        public function get loopStart():uint
        {
            return this.sample.loopStart + this.startLoopAddrsCoarseOffset * 32768 + this.startLoopAddrsOffset;
        }

        public function get loopEnd():uint
        {
            return this.sample.loopEnd + this.endLoopAddrsCoarseOffset * 32768 + this.endLoopAddrsOffset;
        }

        public function get relativeLoopStart():uint
        {
            return this.loopStart - this.start;
        }

        public function get relativeLoopEnd():uint
        {
            return this.loopEnd - this.start;
        }
    }
}
