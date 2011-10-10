package tonfall.format.midi
{
    public class MidiEvent
    {
        private var _position: Number;

        public function MidiEvent( position: Number )
        {
            _position = position;
        }

        public function get position(): Number
        {
            return _position;
        }
    }
}