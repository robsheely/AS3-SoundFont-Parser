package tonfall.format.midi
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import tonfall.core.TimeEventContainer;
    import tonfall.core.TimeEventNote;
    import tonfall.format.FormatError;

    public final class MidiFormat
    {
        public static const TYPE_DESCRIPTION:Vector.<String> = Vector.<String>(
        [
            'single multi-channel track',
            'one or more simultaneous tracks (or MIDIoutputPorts) of a sequence',
            'one or more sequentially independent single-track patterns'
        ]);

        public static function decode(stream:ByteArray):MidiFormat
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
            return new MidiFormat(formatType, timeDivision, tracks);
        }
        private var _formatType:int;
        private var _timeDivision:int;
        private var _tracks:Vector.<MidiTrack>;

        public function MidiFormat(formatType:int, timeDivision:int, tracks:Vector.<MidiTrack>)
        {
            _formatType = formatType;
            _timeDivision = timeDivision;
            _tracks = tracks;
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

        public function toTimeEventContainer(humanize:Number = 0.0):TimeEventContainer
        {
            const container:TimeEventContainer = new TimeEventContainer();
            const tn:int = tracks.length;
            for (var ti:int = 0; ti < tn; ++ti)
            {
                const track:MidiTrack = tracks[ti];
                const channels:Vector.<Vector.<MidiChannelEvent>> = track.channels;
                const cn:int = channels.length;
                for (var ci:int = 0; ci < cn; ++ci)
                {
                    const events:Vector.<MidiChannelEvent> = channels[ci];
                    const table:Dictionary = new Dictionary();
                    const en:int = events.length;
                    for (var ei:int = 0; ei < en; ++ei)
                    {
                        var event:MidiChannelEvent = events[ei];
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
                            if (null != table[event.param0])
                            {
                                trace('Warning: NoteOn while note is playing. (stopping last note...)', event);
                                startEvent = table[event.param0];
                                container.push(createNote(startEvent.param0, startEvent.param1 / 0x7F,
                                    startEvent.position, event.position, humanize));
                            }
                            table[event.param0] = event;
                        }
                        else if (noteOff)
                        {
                            startEvent = table[event.param0];
                            if (null == startEvent)
                            {
                                trace('Warning: NoteOff without NoteOn', event);
                            }
                            else
                            {
                                container.push(createNote(startEvent.param0, startEvent.param1 / 0x7F,
                                    startEvent.position, event.position, humanize));
                                delete table[event.param0];
                            }
                        }
                    }
                    for (var e:* in table)
                    {
                        trace('Warning: NoteOn with NoteOff', e);
                        delete table[e];
                    }
                }
            }
            return container;
        }

        public function toString():String
        {
            return '[MidiFormat type: ' + TYPE_DESCRIPTION[_formatType] + ', timeDivision: ' + _timeDivision +
                ', numTracks: ' + tracks.length + ']';
        }

        public function dispose():void
        {
            _tracks = null;
        }

        private function createNote(note:int, velocity:Number, startPosition:Number, endPosition:Number,
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
