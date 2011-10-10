package tonfall.core
{
    /**
     * Standard midi note <> frequency mapping
     *
     * @author Andre Michelle
     * @param note The note value to be translated to frequency
     * @return The frequency in Hertz (Cycles per second)
     */
    public function noteToFrequency(note:int = 60.0):Number
    {
        return 440.0 * Math.pow(2.0, (note + 3.0) / 12.0 - 6.0);
    }
}
