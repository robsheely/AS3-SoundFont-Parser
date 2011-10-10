package tonfall.format.pcm
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import tonfall.format.FormatError;
    import tonfall.format.FormatInfo;

    public class PCMSound
    {
        [Embed(source = "./bin/swf.bin", mimeType = "application/octet-stream")]
        private static const SWF:Class;

        private var _onComplete:Function;
        private var _sound:Sound;

        public function PCMSound(bytes:ByteArray, info:FormatInfo, onComplete:Function = null)
        {
            if (null == bytes)
            {
                throw new Error('bytes must not be null');
            }
            if (null == info)
            {
                throw new Error('info must not be null');
            }
            _onComplete = onComplete;
            generateSound(bytes, info);
        }

        public function get ready():Boolean
        {
            return null != _sound;
        }

        public function extract(target:ByteArray, length:Number, startPosition:Number = -1):Number
        {
            if (null == _sound)
            {
                return 0.0;
            }
            else
            {
                return _sound.extract(target, length, startPosition);
            }
        }

        public function get length():Number
        {
            if (null == _sound)
            {
                return 0.0;
            }
            else
            {
                return _sound.length;
            }
        }

        public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel
        {
            if (null == _sound)
            {
                return null;
            }
            else
            {
                return _sound.play(startTime, loops, sndTransform);
            }
        }

        public function dispose():void
        {
            _sound = null;
        }

        protected function writeSoundData(swf:ByteArray, data:ByteArray, info:FormatInfo):void
        {
            swf.writeBytes(data, info.dataOffset, info.dataLength);
        }

        private function generateSound(bytes:ByteArray, info:FormatInfo):void
        {
            //-- get naked swf bytearray
            const swf:ByteArray = ByteArray(new SWF());
            swf.endian = Endian.LITTLE_ENDIAN;
            swf.position = swf.length;
            //-- write define sound tag header
            swf.writeShort(0x03bf);
            swf.writeUnsignedInt(info.dataLength + 7);
            //-- assemble audio property byte (uncompressed little endian)
            var byte2:uint = 0x30;
            switch (info.samplingRate)
            {
                case 44100:
                {
                    byte2 |= 0xC;
                    break;
                }
                case 22050:
                {
                    byte2 |= 0x8;
                    break;
                }
                case 11025:
                {
                    byte2 |= 0x4;
                    break;
                }
                default:
                {
                    throw FormatError.SAMPLING_RATE;
                }
            }
            if (2 == info.numChannels)
            {
                byte2 |= 1;
            }
            else if (1 != info.numChannels)
            {
                throw FormatError.NUM_CHANNELS;
            }
            if (16 == info.bits)
            {
                byte2 |= 2;
            }
            else if (8 != info.bits)
            {
                throw FormatError.BIT;
            }
            //-- write define sound tag
            swf.writeShort(1);
            swf.writeByte(byte2);
            swf.writeUnsignedInt(uint(info.numSamples));
            writeSoundData(swf, bytes, info);
            //-- write eof tag in swf stream
            swf.writeShort(1 << 6);
            //-- overwrite swf length
            swf.position = 4;
            swf.writeUnsignedInt(swf.length);
            swf.position = 0;
            var onSWFLoaded:Function = function(event:Event):void
            {
                LoaderInfo(event.target).removeEventListener(Event.COMPLETE, onSWFLoaded);
                onComplete(Sound(new (loader.contentLoaderInfo.applicationDomain.getDefinition('SoundItem') as
                    Class)()));
            };
            const loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
            loader.loadBytes(swf);
        }

        private function onComplete(sound:Sound):void
        {
            _sound = sound;
            if (null != _onComplete)
            {
                if (0 == _onComplete.length)
                {
                    _onComplete();
                    _onComplete = null;
                }
                else if (1 == _onComplete.length)
                {
                    _onComplete(this);
                    _onComplete = null;
                }
                else
                {
                    throw new ArgumentError('Callback must have at maximum one argument (PCMSound).');
                }
            }
        }
    }
}
