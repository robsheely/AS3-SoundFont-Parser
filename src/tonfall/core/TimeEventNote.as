package tonfall.core
{

    /**
     * TimeEventNote describes a note event
     *
     * @author Andre Michelle
     * @see TimeEvent
     */
    public final class TimeEventNote extends TimeEvent
    {
        public var note:Number = 60.0; // C4 in MidiSpace
        public var velocity:Number = 1.0; // full velocity
        public var barDuration:Number = 0.0; // no duration

        public function toString():String
        {
            return '[TimeEventNote barPosition: ' + barPosition + ', barDuration: ' + barDuration + ', note: ' + note +
                ', velocity: ' + velocity + ']';
        }
    }
}
