package tonfall.util
{
    import tonfall.format.IAudioDecoder;

    /**
    * Defines a sheet of an instrument where keys are stored in a single audio file
    *
    * [Check /load/piano.mp3 for instance]
    *
    * @author Andre Michelle
    */
    public interface ISoundSheet
    {
        /**
        * @param note The note that should be played
        * @return The nearest key availble in sheet
        */
        function getNearestKeyIndexByNote(note:int):int;
        /**
        * @param keyIndex The index of the key in sheet
        * @return The actual frequency of the key
        */
        function getFrequencyByKeyIndex(keyIndex:int):Number;
        /**
        * @param keyIndex The index of the key in sheet
        * @return The start position in samples
        */
        function getStartPositionFromKeyIndex(keyIndex:int):Number;
        /**
        * @param keyIndex The index of the key in sheet
        * @return The end position in samples
        */
        function getEndPositionFromKeyIndex(keyIndex:int):Number;
        /**
        * @return The decoder where to read the sheet audio
        */
        function get decoder():IAudioDecoder;
    }
}
