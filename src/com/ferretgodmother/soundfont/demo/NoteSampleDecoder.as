package com.ferretgodmother.soundfont.demo
{
    import flash.utils.ByteArray;

    import com.ferretgodmother.soundfont.NoteSample;
    import com.ferretgodmother.soundfont.chunks.data.Envelope;

    import tonfall.format.pcm.IPCMIOStrategy;
    import tonfall.format.pcm.PCM16BitMono44Khz;
    import tonfall.format.pcm.PCMDecoder;

    public class NoteSampleDecoder
    {
        public var noteSample:NoteSample;

        protected var _decoder:PCMDecoder;
        protected var _buffer:ByteArray = new ByteArray();

        public function NoteSampleDecoder(noteSample:NoteSample)
        {
            this.noteSample = noteSample;
        }

        public function extract(target:ByteArray, length:Number, startPosition:Number):Number
        {
            _buffer.position = 0;
            if (_decoder == null)
            {
                var pcmStrategy:IPCMIOStrategy = new PCM16BitMono44Khz();
                _decoder = new PCMDecoder(noteSample.sample.bytes, pcmStrategy);
            }
            // Tonfall's PCM16BitMono44Khz strategy deals in samples of 16 bits. NoteSample's start, loopStart, end &
            // loopEnd are byte offsets (of 8 bits) so we need to divide them by 2 to arrive at the correct values here
            const tStart:uint = noteSample.start / 2;
            const tLoopStart:uint = noteSample.loopStart / 2;
            const tLoopEnd:uint = noteSample.loopEnd / 2;
            const tLoopOffset:uint = tLoopStart - tStart;
            const tLoopLength:uint = tLoopEnd - tLoopStart;
            var numSamplesRead:int = 0;
            var position:Number = tStart + startPosition;
            // MORE SAMPLES NEEDED?
            var tNumSamplesRead:int = 0;
            while (numSamplesRead < length)
            {
                if (position >= tLoopEnd)
                {
                    position = tLoopStart + (position - tLoopStart) % tLoopLength;
                }
                tNumSamplesRead = _decoder.extract(target, length, position);
                numSamplesRead += tNumSamplesRead;
                position += tNumSamplesRead;
            }
            return numSamplesRead;
        }

        public function getVolumeEnvelope():Envelope
        {
            var envelope:Envelope = new Envelope();
            envelope.delay = noteSample.delayVolEnv;
            envelope.attack = noteSample.attackVolEnv;
            envelope.hold = noteSample.holdVolEnv + timecentToMS(this.keyOffset * noteSample.keyNumToVolEnvHold);
            envelope.decay = noteSample.decayVolEnv + timecentToMS(this.keyOffset * noteSample.keyNumToVolEnvDecay);
            envelope.sustain = noteSample.sustainVolEnv;
            envelope.release = noteSample.releaseVolEnv;
            return envelope;
        }

        public function getModulationEnvelope():Envelope
        {
            var envelope:Envelope = new Envelope();
            envelope.delay = noteSample.delayModEnv;
            envelope.attack = noteSample.attackModEnv;
            envelope.hold = noteSample.holdModEnv + timecentToMS(this.keyOffset * noteSample.keyNumToModEnvHold);
            envelope.decay = noteSample.decayModEnv + timecentToMS(this.keyOffset * noteSample.keyNumToModEnvDecay);
            envelope.sustain = noteSample.sustainModEnv;
            envelope.release = noteSample.releaseModEnv;
            return envelope;
        }

        protected function get keyOffset():int
        {
            return 60 - noteSample.keyNum;
        }

        /* converts the strange AWE32 timecent values to milliseconds */
        protected function timecentToMS(timecent:int):uint
        {
            return Math.pow(2.0, timecent / 1200.0) * 1000.0;
        }
    }
}
