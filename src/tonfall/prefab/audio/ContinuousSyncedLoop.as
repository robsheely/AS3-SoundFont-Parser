package tonfall.prefab.audio
{
    import flash.utils.ByteArray;
    import tonfall.core.BlockInfo;
    import tonfall.core.Processor;
    import tonfall.core.Signal;
    import tonfall.core.SignalBuffer;
    import tonfall.format.IAudioDecoder;

    /**
     * ContinuousSyncedLoop playback an audio file synced to the global Engine position.
     * It does not accept events. It simply plays the audio pitched to adjust the Engine tempo.
     *
     * @author Andre Michelle
     */
    public final class ContinuousSyncedLoop extends Processor
    {
        private static const TARGET:ByteArray = new ByteArray();

        public const signalOutput:SignalBuffer = new SignalBuffer();

        private const target:ByteArray = TARGET; // FASTER ACCESS

        private var _decoder:IAudioDecoder;
        private var _samplesTotal:Number;
        private var _barDuration:Number;

        /**
         * ContinuousSyncedLoop Constructor
         *
         * @param decoder The decoder where audio is located
         * @param samplesTotal The duration in absolute time of the audio
         * @param barDuration The duration in musical time of the audio
         */
        public function ContinuousSyncedLoop(decoder:IAudioDecoder, samplesTotal:Number, barDuration:Number = 1.0)
        {
            _decoder = decoder;
            _samplesTotal = samplesTotal;
            _barDuration = barDuration;
        }

        /**
         * @return The musical duration in bars
         */
        public function get barDuration():Number
        {
            return _barDuration;
        }

        /**
         * @param value The musical duration in bars
         */
        public function set barDuration(value:Number):void
        {
            _barDuration = value;
        }

        /**
         * Writes synced audio into the signalOutput
         *
         * @see Processor
         * @see SignalBuffer
         */
        override public function process(info:BlockInfo):void
        {
            const loopStart:Number = Math.floor(info.barFrom / _barDuration) * _barDuration; // LAST LOOP STARTING POSITION
            //-> MAP MUSICAL LOOP POSITION TO LOOP SAMPLE POSITION
            const sampleStart:Number = (info.barFrom - loopStart) / _barDuration * _samplesTotal;
            const sampleEnd:Number = (info.barTo - loopStart) / _barDuration * _samplesTotal;
            const targetPosition:Number = sampleStart - Math.floor(sampleStart); // AUDIO WAS WRITTEN AT THE BEGINNING OF BYTEARRAY
            const sampleRate:Number = (sampleEnd - sampleStart) / info.numSignals; // PLAYBACK SPEED
            const read:int = (Math.ceil(sampleEnd) - Math.floor(sampleStart)) + 1; // SAMPLE TO BE READ FROM SOURCE (+1 FOR INTERPOLATION)
            readAudioWrapped(read, sampleStart); // READ INTO TARGET
            processNormal(signalOutput.current, targetPosition, sampleRate, info.numSignals);
        }

        /**
         * Writes synced audio to the current stream. Create another method for e.g. volume interpolation (if necessary)
         */
        private function processNormal(current:Signal, position:Number, rate:Number, numSignals:int):void
        {
            var index:int;
            var l0:Number;
            var r0:Number;
            var l1:Number;
            var r1:Number;
            var alpha:Number;
            for (var i:int = 0; i < numSignals; ++i)
            {
                index = position;
                //-- SET TARGET READ POSITION
                target.position = index << 3;
                //-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
                l0 = target.readFloat();
                r0 = target.readFloat();
                l1 = target.readFloat();
                r1 = target.readFloat();
                //-- MIXING RATIO FOR INTERPOLATION
                alpha = position - Math.floor(position);
                //-- WRITE INTERPOLATED AMPLITUDES INTO SIGNALOUTPUT
                current.l = l0 + alpha * (l1 - l0);
                current.r = r0 + alpha * (r1 - r0);
                current = current.next;
                //-- INCREASE POSITION
                position += rate;
            }
        }

        /**
         * If position + total is greater then actual audio, it restarts from the beginning
         */
        private function readAudioWrapped(total:int, position:int):void
        {
            target.position = 0;
            total -= _decoder.extract(TARGET, total, position);
            if (0 < total) // STILL SAMPLES NEEDED
            {
                _decoder.extract(TARGET, total, 0);
            }
        }
    }
}
