package tonfall.core
{
    /**
     * Processor is a member in the engine's processing chain.
     *
     * A Processor can either generate audio or sequence events or both.
     *
     * Every processor accepts events.
     *
     * @author Andre Michelle
     * @see Engine
     */
    public /*abstract*/class Processor
    {
        protected const events:Vector.<TimeEvent> = new Vector.<TimeEvent>();
        protected const engine:Engine = Engine.getInstance();

        public function Processor()
        {
        }

        /**
         * Processor accepts TimeEvent like TimeEventNotes or any implementation of it.
         * All TimeEvents needs to be processed within the next block and removed from internal list.
         *
         * @param event The TimeEvent to be stored for processing
         *
         * @see TimeEvent
         */
        public function addTimeEvent(event:TimeEvent):void
        {
            if (-1 < events.indexOf(event))
            {
                throw new Error('Element already exists.');
            }
            events.push(event);
            events.sort(sortOnPosition);
        }

        /**
         * To be overriden by implementation.
         *
         * @param info Information about the current block
         *
         * @see BlockInfo
         */
        public function process(info:BlockInfo):void
        {
            throw new Error('Method "process" is marked abstract.');
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
