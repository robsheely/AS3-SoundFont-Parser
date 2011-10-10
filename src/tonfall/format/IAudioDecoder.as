package tonfall.format
{
    import flash.utils.ByteArray;

    /**
    * @author Andre Michelle
    */
    public interface IAudioDecoder
    {
        function extract(target:ByteArray, length:Number, startPosition:Number = -1.0):Number;
        function get numSamples():Number;
    }
}
