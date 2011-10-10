package tonfall.core
{
    /**
     * TimeConversion provides conversion between absolute and musical time.
     *
     * One bar is based on 4/4 time signature.
     *
     * @author Andre Michelle
     */
    public final class TimeConversion
    {
        /**
         * Translates musical-time into absolute-time in milliseconds
         *
         * @param bars Musical-time in bars
         * @param bpm Tempo to be taken into account
         *
         * @return Absolute time in milliseconds
         */
        public static function barsToMillis(bars:Number, bpm:Number):Number
        {
            return (bars * 240.0 / bpm) * 1000.0;
        }

        /**
         * Translates musical-time into amount of signals
         *
         * @param bars Musical-time in bars
         * @param bpm Tempo to be taken into account
         *
         * @return The amount of signals
         */
        public static function barsToNumSamples(bars:Number, bpm:Number):Number
        {
            return (bars * 240.0 / bpm) * samplingRate;
        }

        /**
         * Translates absolute-time into musical-time
         *
         * @param millis Absolute time in milliseconds
         * @param bpm Tempo to be taken into account
         *
         * @return Musical-time in bars
         */
        public static function millisToBars(millis:Number, bpm:Number):Number
        {
            return (millis * bpm / 240.0) / 1000.0;
        }

        /**
         * Translates signals into musical-time
         *
         * @param numSignals The amount of signals
         * @param bpm Tempo to be taken into account
         *
         * @return Musical-time in bars
         */
        public static function numSamplesToBars(numSignals:Number, bpm:Number):Number
        {
            return (numSignals * bpm / 240.0) / samplingRate;
        }
    }
}
