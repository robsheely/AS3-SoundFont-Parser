package tonfall.format.pcm
{
    import flash.utils.ByteArray;
    import tonfall.core.Signal;
    import tonfall.format.FormatInfo;

    /**
     * @author Andre Michelle
     */
    public interface IPCMIOStrategy
    {
        /**
         * @return true, if strategy can read format information
         */
        function supports(info:FormatInfo):Boolean;
        /**
         * Reads audio data from source format and write audio data in Flashplayer format (44100Hz,Stereo,Float)
         *
         * @param data ByteArray to read from
         * @param dataOffset position, where audio data starts
         * @param target The ByteArray to write the audio data
         * @param length How many samples must be written
         * @param startPosition position, where to start reading
         */
        function read32BitStereo44KHz(data:ByteArray, dataOffset:Number, target:ByteArray, length:Number,
                                      startPosition:Number):void;
        /**
         * Reads an audio frame into a Signal
         */
        function readFrameInSignal(data:ByteArray, dataOffset:Number, signal:Signal, position:Number):void;
        /**
         * Reads audio data in Flashplayer format (44100Hz,Stereo,Float) and writes audio data to target format
         *
         * @param data ByteArray with incoming audio data in Flashplayer format
         * @param target ByteArray to write the data in target format
         * @param numSamples Number of samples to process
         */
        function write32BitStereo44KHz(data:ByteArray, target:ByteArray, numSamples:uint):void;
        /**
         * @return blockAlign
         */
        function get blockAlign():uint;
        /**
         * @return compressionType
         */
        function get compressionType():Object;
        /**
         * @return samplingRate
         */
        function get samplingRate():Number;
        /**
         * @return numChannels
         */
        function get numChannels():uint;
        /**
         * @return bits
         */
        function get bits():uint;
    }
}
