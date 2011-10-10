package tonfall.core
{
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;

    /**
     * Standard audio driver running on flash.media.Sound
     *
     * @author Andre Michelle
     */
    public final class Driver
    {
        private static var instance:Driver = null;

        public static function getInstance():Driver
        {
            if (null == instance)
            {
                instance = new Driver();
            }
            return instance;
        }

        private const sound:Sound = new Sound();
        private const zeroBytes:ByteArray = new ByteArray();
        private const fillBytes:ByteArray = new ByteArray();

        private var _engine:Engine;
        private var _soundChannel:SoundChannel;
        private var _latency:Number = 0.0;
        private var _running:Boolean;

        public function Driver()
        {
            if (instance != null)
            {
                throw new Error('AudioDriver is Singleton.');
            }
            zeroBytes.length = blockSize << 3;
            fillBytes.length = blockSize << 3;
            sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
        }

        public function get engine():Engine
        {
            return _engine;
        }

        public function set engine(value:Engine):void
        {
            _engine = value;
        }

        public function get latency():Number
        {
            return _latency;
        }

        public function get leftPeak():Number
        {
            if (null == _soundChannel)
            {
                return 0.0;
            }
            return _soundChannel.leftPeak;
        }

        public function get rightPeak():Number
        {
            if (null == _soundChannel)
            {
                return 0.0;
            }
            return _soundChannel.rightPeak;
        }

        public function init():void
        {
            if (null != _soundChannel)
            {
                throw new Error('Cannot inited twice.');
            }
            _soundChannel = sound.play();
            _running = true;
        }

        public function get running():Boolean
        {
            return _running;
        }

        public function set running(running:Boolean):void
        {
            _running = running;
        }

        private function sampleData(event:SampleDataEvent):void
        {
            if (_soundChannel != null)
            {
                // Compute difference from writing and audible audio data
                _latency = event.position / 44.1 - _soundChannel.position;
            }
            if (_engine == null || !_running)
            {
                event.data.writeBytes(zeroBytes);
            }
            else
            {
                fillBytes.position = 0;
                try
                {
                    _engine.render(fillBytes);
                }
                catch (e:Error)
                {
                    trace('Error while rendering Audio.', e.getStackTrace());
                    return; // SHUT DOWN
                }
                event.data.writeBytes(fillBytes);
            }
        }
    }
}
