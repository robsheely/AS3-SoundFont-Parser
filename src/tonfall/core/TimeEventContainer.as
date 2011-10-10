package tonfall.core
{
    /**
     * Very simple container for TimeEvent's
     *
     * No proper data structure, but enough for testing purpose
     *
     * @author Andre Michelle
     */
    public final class TimeEventContainer
    {
        private const vector:Vector.<TimeEvent> = new Vector.<TimeEvent>();

        /**
         * @param event The event to be pushed to the container
         */
        public function push(event:TimeEvent):void
        {
            vector.push(event);
            vector.sort(sortOnPosition);
        }

        /**
         * @param events The events to be pushed to the container
         */
        public function pushMany(... events):void
        {
            vector.push.apply(this, events);
            vector.sort(sortOnPosition);
        }

        /**
         * @param t0 The start position in bars where to filter events
         * @param t1 The end position in bars where to filter events
         *
         * @return A new vector with all events in passed range
         */
        public function interval(t0:Number, t1:Number):Vector.<TimeEvent>
        {
            const events:Vector.<TimeEvent> = new Vector.<TimeEvent>();
            const n:int = vector.length;
            for (var i:int = 0; i < n; ++i)
            {
                var event:TimeEvent = vector[i];
                if (event.barPosition >= t1)
                {
                    return events;
                }
                if (event.barPosition >= t0)
                {
                    events.push(event);
                }
            }
            return events;
        }

        /**
         * @return The number of events in container
         */
        public function get length():int
        {
            return vector.length;
        }

        private function sortOnPosition(a:TimeEvent, b:TimeEvent):int
        {
            if (a.barPosition > b.barPosition)
            {
                return 1;
            }
            if (a.barPosition < b.barPosition)
            {
                return -1;
            }
            return 0;
        }
    }
}
