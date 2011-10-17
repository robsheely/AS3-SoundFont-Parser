/*
    This is a modification of DemoMidi.as from the tonfall engine. (http://code.google.com/p/tonfall/)
*/
package com.ferretgodmother.soundfont.demo
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.utils.setTimeout;

    import com.ferretgodmother.soundfont.SoundFont;
    import com.ferretgodmother.soundfont.SoundFontParser;

    import tonfall.core.blockSize;
    import tonfall.core.Driver;
    import tonfall.core.Engine;
    import tonfall.core.Memory;
    import tonfall.core.TimeEventContainer;
    import tonfall.core.TimeEventContainerSequencer;
    import tonfall.display.AbstractApplication;
    import tonfall.format.midi.MidiFormat;
    import tonfall.prefab.poly.PolySynth;

    [Event(name="playing", type="flash.events.Event")]
    public class MidiSoundFontPlayer extends EventDispatcher
    {
        // Kreisleriana, Opus 16 (1838) - Robert Schumann
        [Embed(source = 'assets/schumann.mid', mimeType = 'application/octet-stream')]
        protected static const SCHUMANN_CLASS:Class;

        protected const driver:Driver = Driver.getInstance();
        protected const engine:Engine = Engine.getInstance();

        protected var _container:TimeEventContainer;
        protected var _sequencer:TimeEventContainerSequencer;
        protected var _generator:PolySynth;
        protected var _soundFont:SoundFont;
        protected var _inited:Boolean = false;

        public function MidiSoundFontPlayer()
        {
        }

        public function get soundFont():SoundFont
        {
            return _soundFont;
        }

        public function set soundFont(value:SoundFont):void
        {
            _soundFont = value;
        }

        public function get isPlaying():Boolean
        {
            return this.driver.running;
        }

        public function stop():void
        {
            this.driver.running = false;
            if (_generator != null)
            {
                _generator.clear();
            }
            _generator = null;
        }

        public function play():void
        {
            if (_container == null)
            {
                var schumann:MidiFormat = MidiFormat.decode(new SCHUMANN_CLASS());
                _container = schumann.toTimeEventContainer();
            }
            if (_generator != null)
            {
                _generator.clear();
            }
            _generator = new PolySynth(new SoundFontVoiceFactory(_soundFont));
            this.driver.running = false;
            this.engine.barPosition = 0.0;
            _sequencer = new TimeEventContainerSequencer(_container);
            _sequencer.timeEventTarget = _generator;
            this.engine.processors[0] = _sequencer;
            this.engine.processors[1] = _generator;
            this.engine.input = _generator.signalOutput;
            // preallocate memory for processing single block
            Memory.length = blockSize << 3;
            driver.engine = engine;
            // delay call to avoid glitches (Flashplayer issue)
            if (!_inited)
            {
                _inited = true;
                setTimeout(driver.init, 100);
            }
            this.driver.running = true;
            dispatchEvent(new Event("playing"));
        }

        protected function format_onProgress(event:Event):void
        {
            dispatchEvent(event);
        }
    }
}

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

class SoundFontVoice implements IPolySynthVoice
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

import flash.utils.ByteArray;

import com.ferretgodmother.soundfont.NoteSample;
import com.ferretgodmother.soundfont.chunks.data.Envelope;

import tonfall.format.pcm.IPCMIOStrategy;
import tonfall.format.pcm.PCM16BitMono44Khz;
import tonfall.format.pcm.PCMDecoder;

class NoteSampleDecoder
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
}

import com.ferretgodmother.soundfont.SoundFont;

import tonfall.core.TimeEventNote;
import tonfall.prefab.poly.IPolySynthVoice;
import tonfall.prefab.poly.IPolySynthVoiceFactory;

class SoundFontVoiceFactory implements IPolySynthVoiceFactory
{
    protected var _soundFont:SoundFont;
    protected var _lastID:int = -1;

    public function SoundFontVoiceFactory(soundFont:SoundFont)
    {
        _soundFont = soundFont;
    }

    public function create(event:TimeEventNote):IPolySynthVoice
    {
        var voice:SoundFontVoice = new SoundFontVoice(_soundFont, ++_lastID);
        return voice;
    }
}

