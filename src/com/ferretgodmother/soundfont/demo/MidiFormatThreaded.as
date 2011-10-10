package com.ferretgodmother.soundfont.demo
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.Timer;

    import mx.core.UIComponent;

    import com.ferretgodmother.soundfont.utils.UIUtilities;

    import tonfall.core.TimeEventContainer;
    import tonfall.core.TimeEventNote;
    import tonfall.format.FormatError;
    import tonfall.format.midi.MidiChannelEvent;
    import tonfall.format.midi.MidiTrack;

    public class MidiFormatThreaded extends EventDispatcher
    {
        public static function decode(stream:ByteArray):MidiFormatThreaded
        {
            stream.endian = Endian.BIG_ENDIAN;
            stream.position = 0;
            //-- HEADER
            if (stream.readUnsignedInt() == 0x4D546864) // MThd
            {
                if (stream.readUnsignedInt() != 6)
                {
                    throw FormatError.HEADER_CORRUPT;
                }
            }
            else
            {
                throw FormatError.HEADER_CORRUPT;
            }
            const formatType:int = stream.readUnsignedShort();
            const numTracks:int = stream.readUnsignedShort();
            // TODO: Midi are always 4/4?
            const timeDivision:int = stream.readShort() * 4;
            const tracks:Vector.<MidiTrack> = new Vector.<MidiTrack>(numTracks, true);
            var track:MidiTrack;
            var trackData:ByteArray;
            var trackSize:int;
            for (var i:int = 0; i < numTracks; ++i)
            {
                if (stream.readUnsignedInt() == 0x4D54726B) // MTrk (TRACK CHUNK)
                {
                    trackSize = stream.readUnsignedInt();
                    trackData = new ByteArray();
                    stream.readBytes(trackData, 0, trackSize);
                    track = new MidiTrack(i);
                    track.decode(trackData, timeDivision);
                    tracks[i] = track;
                }
                else
                {
                    throw FormatError.TAG_UNKNOWN;
                }
            }
            if (stream.position != stream.length)
            {
                throw FormatError.SIZE_MISMATCH;
            }
            return new MidiFormatThreaded(formatType, timeDivision, tracks);
        }

        protected var _formatType:int;
        protected var _timeDivision:int;
        protected var _tracks:Vector.<MidiTrack>;
        protected var _track:MidiTrack;
        protected var _channels:Vector.<Vector.<MidiChannelEvent>>;
        protected var _channelEvents:Vector.<MidiChannelEvent>
        protected var _table:Dictionary;
        protected var _container:TimeEventContainer;
        protected var _uiComponent:UIComponent;
        protected var _humanize:Number;
        protected var _numTracks:int;
        protected var _trackIndex:int;
        protected var _numChannels:int;
        protected var _channelIndex:int;
        protected var _numEvents:int;
        protected var _callLaterFunction:Function;
        protected var _callLaterTimer:Timer = new Timer(33, 1);

        public function MidiFormatThreaded(formatType:int, timeDivision:int, tracks:Vector.<MidiTrack>)
        {
            _formatType = formatType;
            _timeDivision = timeDivision;
            _tracks = tracks;
            _callLaterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, callLaterTimer_onTimerComplete);
        }

        protected function callLaterTimer_onTimerComplete(event:TimerEvent):void
        {
            _callLaterFunction.call(this);
        }

        public function get formatType():int
        {
            return _formatType;
        }

        public function get timeDivision():int
        {
            return _timeDivision;
        }

        public function get tracks():Vector.<MidiTrack>
        {
            return _tracks;
        }

        public function generateTimeEventContainer(humanize:Number = 0.0):void
        {
            _humanize = humanize;
            _container = new TimeEventContainer();
            _numTracks = tracks.length;
            _trackIndex = 0;
            addTrack();
        }

        protected function onTrackComplete():void
        {
            ++_trackIndex;
            if (_trackIndex < _numTracks)
            {
                addTrack();
            }
            else
            {
                dispatchEvent(new MidiFormatThreadedEvent(MidiFormatThreadedEvent.CONTAINER_COMPLETE, _container));
            }
        }

        protected function onChannelComplete():void
        {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false,
                                            _trackIndex * _numChannels + _channelIndex, _numTracks * _numChannels));
            ++_channelIndex;
            if (_channelIndex < _numChannels)
            {
                addChannel();
            }
            else
            {
                _callLaterFunction = onTrackComplete;
                _callLaterTimer.reset();
                _callLaterTimer.start();
            }
        }

        protected function addTrack():void
        {
            _track = tracks[_trackIndex];
            _channels = _track.channels;
            _numChannels = _channels.length;
            _channelIndex = 0;
            addChannel();
        }

        protected function addChannel():void
        {
            _channelEvents = _channels[_channelIndex];
            _numEvents = _channelEvents.length;
            _table = new Dictionary();
            for (var i:int = 0; i < _numEvents; ++i)
            {
                addEvent(i);
            }
            for (var e:* in _table)
            {
                trace('Warning: NoteOn with NoteOff', e);
                delete _table[e];
            }
            _callLaterFunction = onChannelComplete;
            _callLaterTimer.reset();
            _callLaterTimer.start();
        }

        protected function addEvent(eventIndex:int):void
        {
            var event:MidiChannelEvent = _channelEvents[eventIndex];
            var startEvent:MidiChannelEvent;
            var noteOn:Boolean = event.type == MidiChannelEvent.NOTE_ON;
            var noteOff:Boolean = event.type == MidiChannelEvent.NOTE_OFF;
            if (noteOn && 0 == event.param1)
            {
                noteOn = false;
                noteOff = true;
            }
            if (noteOn)
            {
                if (null != _table[event.param0])
                {
                    trace('Warning: NoteOn while note is playing. (stopping last note...)', event);
                    startEvent = _table[event.param0];
                    _container.
                        push(createNote(startEvent.param0, startEvent.param1 / 0x7F, startEvent.position,
                                        event.position, _humanize));
                }
                _table[event.param0] = event;
            }
            else if (noteOff)
            {
                startEvent = _table[event.param0];
                if (null == startEvent)
                {
                    trace('Warning: NoteOff without NoteOn', event);
                }
                else
                {
                    _container.push(createNote(startEvent.param0, startEvent.param1 / 0x7F, startEvent.position,
                                    event.position, _humanize));
                    delete _table[event.param0];
                }
            }
        }

        protected function createNote(note:int, velocity:Number, startPosition:Number, endPosition:Number,
                                      humanize:Number):TimeEventNote
        {
            if (startPosition > endPosition)
            {
                throw new RangeError();
            }
            const event:TimeEventNote = new TimeEventNote();
            event.barPosition = startPosition + Math.random() * humanize;
            event.barDuration = endPosition - startPosition;
            event.note = note;
            event.velocity = velocity;
            return event;
        }
    }
}