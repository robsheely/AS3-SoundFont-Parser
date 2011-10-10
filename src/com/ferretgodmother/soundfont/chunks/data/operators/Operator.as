package com.ferretgodmother.soundfont.chunks.data.operators
{
    import com.ferretgodmother.soundfont.SFObject;

    /*
    struct sfGenList
    {
        SFGenerator sfGenOper;
        genAmountType genAmount;
    };
    */

    public class Operator extends SFObject
    {
        public static const START_ADDRS_OFFSET:int = 0;
        public static const END_ADDRS_OFFSET:int = 1;
        public static const START_LOOP_ADDRS_OFFSET:int = 2;
        public static const END_LOOP_ADDRS_OFFSET:int = 3;
        public static const START_ADDRS_COARSE_OFFSET:int = 4;
        public static const MOD_LFO_TO_PITCH:int = 5;
        public static const VIB_LFO_TO_PITCH:int = 6;
        public static const MOD_ENV_TO_PITCH:int = 7;
        public static const INITIAL_FILTER_FC:int = 8;
        public static const INITIAL_FILTER_Q:int = 9;
        public static const MOD_LFO_TO_FILTER_FC:int = 10;
        public static const MOD_ENV_TO_FILTER_FC:int = 11;
        public static const END_ADDRS_COARSE_OFFSET:int = 12;
        public static const MOD_LFO_TO_RecordLUME:int = 13;
        public static const UNUSED_1:int = 14;
        public static const CHORUS_EFFECTS_SEND:int = 15;
        public static const REVERB_EFFECTS_SEND:int = 16;
        public static const PAN:int = 17;
        public static const UNUSED_2:int = 18;
        public static const UNUSED_3:int = 19;
        public static const UNUSED_4:int = 20;
        public static const DELAY_MOD_LFO:int = 21;
        public static const FREQ_MOD_LFO:int = 22;
        public static const DELAY_VIB_LFO:int = 23;
        public static const FREQ_VIB_LFO:int = 24;
        public static const DELAY_MOD_ENV:int = 25;
        public static const ATTACK_MOD_ENV:int = 26;
        public static const HOLD_MOD_ENV:int = 27;
        public static const DECAY_MOD_ENV:int = 28;
        public static const SUSTAIN_MOD_ENV:int = 29;
        public static const RELEASE_MOD_ENV:int = 30;
        public static const KEYNUM_TO_MOD_ENV_HOLD:int = 31;
        public static const KEYNUM_TO_MOD_ENV_DECAY:int = 32;
        public static const DELAY_RecordL_ENV:int = 33;
        public static const ATTACK_RecordL_ENV:int = 34;
        public static const HOLD_RecordL_ENV:int = 35;
        public static const DECAY_RecordL_ENV:int = 36;
        public static const SUSTAIN_RecordL_ENV:int = 37;
        public static const RELEASE_RecordL_ENV:int = 38;
        public static const KEYNUM_TO_RecordL_ENV_HOLD:int = 39;
        public static const KEYNUM_TO_RecordL_ENV_DECAY:int = 40;
        public static const INSTRUMENT:int = 41;
        public static const RESERVED_1:int = 42;
        public static const KEY_RANGE:int = 43;
        public static const VEL_RANGE:int = 44;
        public static const START_LOOP_ADDRS_COARSE_OFFSET:int = 45;
        public static const KEY_NUM:int = 46;
        public static const VELOCITY:int = 47;
        public static const INITIAL_ATTENUATION:int = 48;
        public static const RESERVED_2:int = 49;
        public static const END_LOOP_ADDRS_COARSE_OFFSET:int = 50;
        public static const COARSE_TUNE:int = 51;
        public static const FINE_TUNE:int = 52;
        public static const SAMPLE_ID:int = 53;
        public static const SAMPLE_MODES:int = 54;
        public static const RESERVED3:int = 55;
        public static const SCALE_TUNING:int = 56;
        public static const EXCLUSIVE_CLASS:int = 57;
        public static const OVERRIDING_ROOT_KEY:int = 58;
        public static const UNUSED_5:int = 59;
        public static const END_OPER:int = 60;

        public static const NAMES:Array =
        [
            "startAddrsOffset", "endAddrsOffset", "startLoopAddrsOffset", "endLoopAddrsOffset",
            "startAddrsCoarseOffset", "modLfoToPitch", "vibLfoToPitch", "modEnvToPitch",
            "initialFilterFc", "initialFilterQ", "modLfoToFilterFc", "modEnvToFilterFc",
            "endAddrsCoarseOffset", "modLfoToVolume", "unused1", "chorusEffectsSend",
            "reverbEffectsSend", "pan", "unused2", "unused3", "unused4", "delayModLFO",
            "freqModLFO", "delayVibLFO", "freqVibLFO", "delayModEnv", "attackModEnv",
            "holdModEnv", "decayModEnv", "sustainModEnv", "releaseModEnv", "keyNumToModEnvHold",
            "keyNumToModEnvDecay", "delayVolEnv", "attackVolEnv", "holdVolEnv", "decayVolEnv",
            "sustainVolEnv", "releaseVolEnv", "keyNumToVolEnvHold", "keyNumToVolEnvDecay",
            "instrumentID", "reserved1", "keyRange", "velRange", "startLoopAddrsCoarseOffset",
            "keyNum", "velocity", "initialAttenuation", "reserved2", "endLoopAddrsCoarseOffset",
            "coarseTune", "fineTune", "sampleID", "sampleMode", "reserved3", "scaleTuning",
            "exclusiveClass", "overridingRootKey", "unused5", "endOper"
        ];

        public var id:int;
        public var amount:int;
        public var defaultValue:*;
        //public var name:String;
        public var description:String;

        public function Operator(id:int, amount:int)
        {
            this.id = id;
            super(this.name);
            this.amount = amount;
            this.nonSerializedProperties.push("isUnusedType");
        }

        public function get name():String
        {
            return NAMES[this.id];
        }

        public function get isUnusedType():Boolean
        {
            return false;
        }
    }
}