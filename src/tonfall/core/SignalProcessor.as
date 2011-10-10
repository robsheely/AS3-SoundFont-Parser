package tonfall.core
{

    /**
     * SignalProcessor provides sample-exact event processing.
     *
     * When a TimeEvent (like a note) is located for processing inside current block,
     * the SignalProcessor ensures that the event will be executed at proper position.
     *
     * @author Andre Michelle
     * @see Signal
     * @see SignalBuffer
     * @see Processor
     * @see BlockInfo
     */
    public /*abstract*/class SignalProcessor extends Processor
    {
        public function SignalProcessor()
        {
        }

        override public final function process(info:BlockInfo):void
        {
            var event:TimeEvent;
            var localIndex:int = 0;
            var remaining:int = info.numSignals;
            var eventOffset:int;
            while (events.length) // if events located
            {
                event = events.shift(); // check first
                eventOffset = engine.deltaBlockIndexAt(event.barPosition) - localIndex; // offset in numSignals
                if (0 < eventOffset) // if signal processing needed
                {
                    // process signals
                    processSignals(eventOffset);
                    // advance in buffer locally
                    remaining -= eventOffset;
                    localIndex += eventOffset;
                }
                // execute event
                processTimeEvent(event);
                event.dispose();
            }
            if (remaining)
            {
                // process rest of block
                processSignals(remaining);
            }
        }

        /**
         * This method will be called whenever a received TimeEvent needs to be executed.
         *
         * @param event The TimeEvent to be executed.
         */
        protected function processTimeEvent(event:TimeEvent):void
        {
            throw new Error('Method "processTimeEvent" is marked abstract.');
        }

        /**
         * This method will be called when audio processing must be done.
         *
         * @param numSignals The number of signals that needs to be processed.
         */
        protected function processSignals(numSignals:int):void
        {
            throw new Error('Method "processSignals" is marked abstract.');
        }
    }
}
