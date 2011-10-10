package tonfall.core
{

    /**
     * Simple TimeEventSequencer for TimeEventContainer
     *
     * Feeds a target processor with events from a container
     *
     * @author Andre Michelle
     *
     * @see TimeEventContainer
     * @see TimeEvent
     */
    public final class TimeEventContainerSequencer extends Processor
    {
        private var _timeEventTarget:Processor;
        private var _container:TimeEventContainer;

        public function TimeEventContainerSequencer(container:TimeEventContainer)
        {
            _container = container;
        }

        /**
         * To be called by Engine.
         *
         * @param info The information that describe the current block.
         */
        override public function process(info:BlockInfo):void
        {
            const events:Vector.<TimeEvent> = _container.interval(info.barFrom, info.barTo);
            const n:int = events.length;
            for (var i:int = 0; i < n; ++i)
            {
                _timeEventTarget.addTimeEvent(events[i]);
            }
        }

        /**
         * Sets the processor that will receive the events.
         *
         * @param value The processor where to send the events
         */
        public function set timeEventTarget(value:Processor):void
        {
            _timeEventTarget = value;
        }

        /**
         * @return The Processor that receives the events
         */
        public function get timeEventTarget():Processor
        {
            return _timeEventTarget;
        }
    }
}
