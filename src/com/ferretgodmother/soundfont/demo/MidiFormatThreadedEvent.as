package com.ferretgodmother.soundfont.demo
{
    import flash.events.Event;
    import tonfall.core.TimeEventContainer;

    public class MidiFormatThreadedEvent extends Event
    {
        public static const TRACK_COMPLETE:String = "MidiFormatThreadedEvent_trackComplete";
        public static const CHANNEL_COMPLETE:String = "MidiFormatThreadedEvent_channelComplete";
        public static const CONTAINER_COMPLETE:String = "MidiFormatThreadedEvent_containerComplete";

        public var container:TimeEventContainer;

        public function MidiFormatThreadedEvent(type:String, container:TimeEventContainer = null,
                                                bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.container = container;
        }

        override public function clone():Event
        {
            return new MidiFormatThreadedEvent(this.type, this.container, this.bubbles, this.cancelable);
        }
    }
}
