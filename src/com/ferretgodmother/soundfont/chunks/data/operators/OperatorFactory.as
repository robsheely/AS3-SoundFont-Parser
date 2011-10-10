package com.ferretgodmother.soundfont.chunks.data.operators
{
    import flash.utils.Dictionary;

    import com.ferretgodmother.soundfont.chunks.Subchunk;
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.data.GeneratorsSubchunk;

    public class OperatorFactory
    {
        public static const CLASSES:Dictionary = createClassesDictionary();

        public static function createClassesDictionary():Dictionary
        {
            var classes:Dictionary = new Dictionary(false);
            classes[Operator.START_ADDRS_OFFSET] = StartAddressOffset;
            classes[Operator.END_ADDRS_OFFSET] = EndAddressOffset;
            classes[Operator.START_LOOP_ADDRS_OFFSET] = StartLoopAddressOffset;
            classes[Operator.END_LOOP_ADDRS_OFFSET] = EndLoopAddressOffset;
            classes[Operator.START_ADDRS_COARSE_OFFSET] = StartAddressCoarseOffset;
            classes[Operator.MOD_LFO_TO_PITCH] = ModulationLFOToPitch;
            classes[Operator.VIB_LFO_TO_PITCH] = VibratoLFOToPitch;
            classes[Operator.MOD_ENV_TO_PITCH] = ModulationEnvelopeToPitch;
            classes[Operator.INITIAL_FILTER_FC] = InitialFilterFC;
            classes[Operator.INITIAL_FILTER_Q] = InitialFilterQ;
            classes[Operator.MOD_LFO_TO_FILTER_FC] = ModulationLFOToFilterFC;
            classes[Operator.MOD_ENV_TO_FILTER_FC] = ModulationEnvelopeToFilterFC;
            classes[Operator.END_ADDRS_COARSE_OFFSET] = EndAddressCoarseOffset;
            classes[Operator.MOD_LFO_TO_RecordLUME] = ModulationLFOToVolume;
            classes[Operator.CHORUS_EFFECTS_SEND] = ChorusEffectsSend;
            classes[Operator.REVERB_EFFECTS_SEND] = ReverbEffectsSend;
            classes[Operator.PAN] = Pan;
            classes[Operator.DELAY_MOD_LFO] = DelayModulationLFO;
            classes[Operator.FREQ_MOD_LFO] = FrequencyModulationLFO;
            classes[Operator.DELAY_VIB_LFO] = DelayVibratoLFO;
            classes[Operator.FREQ_VIB_LFO] = FrequencyVibratoLFO;
            classes[Operator.DELAY_MOD_ENV] = DelayModulationEnvelope;
            classes[Operator.ATTACK_MOD_ENV] = AttackModulationEnvelope;
            classes[Operator.HOLD_MOD_ENV] = HoldModulationEnvelope;
            classes[Operator.DECAY_MOD_ENV] = DecayModulationEnvelope;
            classes[Operator.SUSTAIN_MOD_ENV] = SustainModulationEnvelope;
            classes[Operator.RELEASE_MOD_ENV] = ReleaseModulationEnvelope;
            classes[Operator.KEYNUM_TO_MOD_ENV_HOLD] = KeyNumToModulationEnvelopeHold;
            classes[Operator.KEYNUM_TO_MOD_ENV_DECAY] = KeyNumToModulationEnvelopeDecay;
            classes[Operator.DELAY_RecordL_ENV] = DelayVolumeEnvelope;
            classes[Operator.ATTACK_RecordL_ENV] = AttackVolumeEnvelope;
            classes[Operator.HOLD_RecordL_ENV] = HoldVolumeEnvelope;
            classes[Operator.DECAY_RecordL_ENV] = DecayVolumeEnvelope;
            classes[Operator.SUSTAIN_RecordL_ENV] = SustainVolumeEnvelope;
            classes[Operator.RELEASE_RecordL_ENV] = ReleaseVolumeEnvelope;
            classes[Operator.KEYNUM_TO_RecordL_ENV_HOLD] = KeyNumToVolumeEnvelopeHold;
            classes[Operator.KEYNUM_TO_RecordL_ENV_DECAY] = KeyNumToVolumeEnvelopeDecay;
            classes[Operator.INSTRUMENT] = Instrument;
            classes[Operator.KEY_RANGE] = KeyRange;
            classes[Operator.VEL_RANGE] = VelocityRange;
            classes[Operator.START_LOOP_ADDRS_COARSE_OFFSET] = StartLoopAddressCoarseOffset;
            classes[Operator.KEY_NUM] = KeyNumOverride;
            classes[Operator.VELOCITY] = VelocityOverride;
            classes[Operator.INITIAL_ATTENUATION] = InitialAttenuation;
            classes[Operator.END_LOOP_ADDRS_COARSE_OFFSET] = EndLoopAddressCoarseOffset;
            classes[Operator.COARSE_TUNE] = CoarseTune;
            classes[Operator.FINE_TUNE] = FineTune;
            classes[Operator.SAMPLE_ID] = SampleID;
            classes[Operator.SAMPLE_MODES] = SampleModes;
            classes[Operator.SCALE_TUNING] = ScaleTuning;
            classes[Operator.EXCLUSIVE_CLASS] = ExclusiveClass;
            classes[Operator.OVERRIDING_ROOT_KEY] = OverridingRootKey;
            classes[Operator.UNUSED_1] = UnusedOperator;
            classes[Operator.UNUSED_2] = UnusedOperator;
            classes[Operator.UNUSED_3] = UnusedOperator;
            classes[Operator.UNUSED_4] = UnusedOperator;
            classes[Operator.UNUSED_5] = UnusedOperator;
            classes[Operator.RESERVED_1] = UnusedOperator;
            classes[Operator.RESERVED_2] = UnusedOperator;
            classes[Operator.RESERVED3] = UnusedOperator;
            classes[Operator.END_OPER] = UnusedOperator;
            return classes;
        }

        public static function create(bytes:SFByteArray):Operator
        {
            var type:int = bytes.readWord();
            var generatorClass:Class = getClass(type);
            var amount:*;
            switch (type)
            {
                case Operator.KEY_RANGE:
                case Operator.VEL_RANGE:
                {
                    var low:int = bytes.readByte();
                    var high:int = bytes.readByte();
                    amount = [low, high];
                    break;
                }
                case Operator.INSTRUMENT:
                case Operator.SAMPLE_ID:
                {
                    amount = bytes.readUnsignedShort();
                    break;
                }
                default:
                {
                    amount = bytes.readShort();
                    break;
                }
            }
            return new generatorClass(amount);
        }

        protected static function getClass(type:int):Class
        {
            if (!CLASSES.hasOwnProperty(type))
            {
                //throw new Error("Unknown Generator Type: " + type);
                trace("OperatorFactory::getClass: Unknown Generator Type: " + type);
                return UnusedOperator;
            }
            return CLASSES[type];
        }
    }
}
