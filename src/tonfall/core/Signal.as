package tonfall.core
{
    /**
     * Stereo audio data linked list item
     *
     * @author Andre Michelle
     */
    public final class Signal
    {
        public var l:Number = 0.0; // LEFT CHANNEL
        public var r:Number = 0.0; // RIGHT CHANNEL
        public var next:Signal; // NEXT POINTER
    }
}
