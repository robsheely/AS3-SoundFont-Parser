package com.ferretgodmother.soundfont.demo
{
    import com.ferretgodmother.soundfont.InstrumentZone;
    import com.ferretgodmother.soundfont.NoteSample;
    import com.ferretgodmother.soundfont.SoundFont;
    import com.ferretgodmother.soundfont.SoundFontParser;

    import tonfall.core.Engine;
    import tonfall.core.Memory;
    import tonfall.core.Signal;
    import tonfall.core.TimeConversion;
    import tonfall.core.TimeEvent;
    import tonfall.core.TimeEventNote;
    import tonfall.core.noteToFrequency;
    import tonfall.prefab.poly.IPolySynthVoice;

    public class SoundFontVoice implements IPolySynthVoice
    {
        protected const engine:Engine = Engine.getInstance();
        protected const RELEASE_DURATION:int = 8820; // 200ms

        public var id:int = -1;
        // Lazy envelope built
        protected var _envelopePointer:int;
        protected var _soundFont:SoundFont;
        protected var _keyNum:int;
        protected var _velocity:Number;
        protected var _noteSampleDecoder:NoteSampleDecoder;
        protected var _mono:Boolean = true
        protected var _position:int = 0;
        protected var _rate:Number;
        protected var _end:Number;

        public function SoundFontVoice(soundFont:SoundFont, id:int)
        {
            _soundFont = soundFont;
            this.id = id;
        }

        public function start(event:TimeEvent):void
        {
            _keyNum = TimeEventNote(event).note;
            _velocity = TimeEventNote(event).velocity;
            // Tonfall's velocity is a floating point value from 0-1. Midi's velocity is an int from 0-127.
            var noteSample:NoteSample = _soundFont.getNoteSample(_keyNum, _velocity * 127);
            _noteSampleDecoder = new NoteSampleDecoder(noteSample);
            _envelopePointer = TimeConversion.barsToNumSamples(TimeEventNote(event).barDuration, engine.bpm);
            _position = noteSample.start / 2;
            _end = noteSample.loopEnd / 2;
            const sampleFrequency:Number = noteToFrequency(noteSample.rootKey);
            const noteFrequency:Number = noteToFrequency(_keyNum);
            _rate = noteFrequency / sampleFrequency;
        }

        public function stop():void
        {
            //

        }

        public function processAdd(current:Signal, numSignals:int):Boolean
        {
            Memory.position = 0;
            var startPos:Number = _position;
            var endPos:Number = startPos + numSignals * _rate;
            if (endPos > _end)
            {
                endPos = _end;
            }
            const intStartPos:int = int(startPos);
            const intEndPos:int = int(endPos);
            //-- Extract Samples
            _noteSampleDecoder.extract(Memory, intEndPos + 2 - intStartPos, intStartPos);
            var bufferPosition:Number = startPos - intStartPos;
            for (var i:int = 0; i < numSignals; ++i)
            {
                _position += _rate;
                if (_position >= _end)
                {
                    return true;
                }
                var volume:Number;
                if (0 < _envelopePointer--)
                {
                    volume = 1.0;
                }
                else if (-RELEASE_DURATION > _envelopePointer)
                {
                    return true;
                }
                else
                {
                    volume = 1.0 + _envelopePointer / RELEASE_DURATION;
                }
                volume *= _velocity;
                var intBufferPosition:int = int(bufferPosition);
                var fracBufferPosition:Number = bufferPosition - intBufferPosition;
                bufferPosition += _rate;
                //-- Set target read position
                Memory.position = intBufferPosition << 3;
                //-- Read 4 samples (two for each stereo channel) so we can use linear interpolation
                var l0:Number = Memory.readFloat();
                var r0:Number = Memory.readFloat();
                var l1:Number = Memory.readFloat();
                var r1:Number = Memory.readFloat();
                //-- Write interpolated amplitudes into the stream
                current.l += (l0 + fracBufferPosition * (l1 - l0)) * volume;
                current.r += (r0 + fracBufferPosition * (r1 - r0)) * volume;
                current = current.next;
            }
            return false;
        }

        public function dispose():void
        {
            _soundFont = null;
        }
    }
}
