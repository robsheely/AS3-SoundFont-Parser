package tonfall.format.midi
{
    import flash.utils.ByteArray;

    public final class MidiChannelEvent extends MidiEvent
    {
        public static const NOTE_ON:int = 0x90;
        public static const NOTE_OFF:int = 0x80;
        public static const AFTERTOUCH:int = 0xA0;
        public static const CONTROLLER:int = 0xB0;
        public static const PROGRAM_CHANGE:int = 0xC0;
        public static const CHANNEL_AFTERTOUCH:int = 0xD0;
        public static const PITCH_BEND:int = 0xE0;
        private var _channelNum:int;
        private var _type:int;
        private var _param0:int;
        private var _param1:int;

        public function MidiChannelEvent(pos:Number)
        {
            super(pos);
        }

        public function get channelNum():int
        {
            return _channelNum;
        }

        public function get type():int
        {
            return _type;
        }

        public function get param0():int
        {
            return _param0;
        }

        public function get param1():int
        {
            return _param1;
        }

        public function toString():String
        {
            return '[MidiChannelEvent position: ' + position + ',channelNum: ' + _channelNum + ', type: ' + _type + ']';
        }

        internal function decode(stream:ByteArray, byte:int):void
        {
            _channelNum = byte & 0x0f;
            _type = byte & 0xf0;
            switch (_type)
            {
                case NOTE_OFF:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                case NOTE_ON:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                case AFTERTOUCH:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                case CONTROLLER:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                case PROGRAM_CHANGE:
                {
                    _param0 = stream.readUnsignedByte();
                    break;
                }
                case CHANNEL_AFTERTOUCH:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                case PITCH_BEND:
                {
                    _param0 = stream.readUnsignedByte();
                    _param1 = stream.readUnsignedByte();
                    break;
                }
                default:
                {
                    skipMessage(stream);
                    break;
                }
            }
        }
    }
}
