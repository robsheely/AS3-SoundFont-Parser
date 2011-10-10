package tonfall.format.aiff
{
    import tonfall.data.IeeeExtended;
    import tonfall.format.FormatError;
    import tonfall.format.FormatInfo;
    import tonfall.format.pcm.IPCMIOStrategy;
    import tonfall.format.pcm.PCMDecoder;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    /**
    * @author Andre Michelle
    */
    public final class AIFFDecoder extends PCMDecoder
    {
        public static function parseHeader( bytes: ByteArray ): FormatInfo
        {
            bytes.endian = Endian.BIG_ENDIAN;

            var ckID: String = bytes.readUTFBytes( 4 );
            var ckDataSize: int = bytes.readInt();

            if( ckID != AIFFTags.FORM )
            {
                throw FormatError.TAG_MISMATCH;
                return;
            }

            if( ckDataSize != bytes.length - 8 ) // SUBTRACT ID & SIZE
            {
                throw FormatError.SIZE_MISMATCH;
            }

            const formType: String = bytes.readUTFBytes( 4 );

            if( formType != AIFFTags.AIFF )
            {
                throw FormatError.TAG_MISMATCH;
            }

            var compressionType: Object;
            var numChannels: uint;
            var samplingRate: Number;
            var bits: uint;
            var blockAlign: uint;
            var dataOffset: uint;
            var dataLength: uint;
            var numSamples: uint;

            var ckPosition: uint;

            for(;;)
            {
                //-- NEXT CHUNK
                ckID = bytes.readUTFBytes( 4 );
                ckDataSize = bytes.readInt();
                ckPosition = bytes.position;

                switch( ckID )
                {
                    case AIFFTags.COMM:
                        numChannels  = bytes.readUnsignedShort();
                        numSamples   = bytes.readUnsignedInt();
                        bits         = bytes.readUnsignedShort();
                        samplingRate = IeeeExtended.inverse( bytes );
                        compressionType = bytes.readUTFBytes( 4 );

                        blockAlign = ( bits >> 3 ) * numChannels;
                        break;

                    case AIFFTags.SSND:
                        dataOffset = bytes.position;
                        dataLength = ckDataSize;
                        break;

                    default:
                        // AIFF allows additional tags to store extra information like markers (skip)
                        break;
                }

                ckPosition += ckDataSize;

                if( ckPosition >= bytes.length ) // EOF
                    break;

                bytes.position = ckPosition;
            }

            if( numSamples != dataLength / blockAlign )
            {
                throw FormatError.UNKNOWN;
            }

            return new FormatInfo( compressionType, samplingRate, numChannels, bits, numSamples, dataOffset );
        }

        private static const STRATEGIES : Vector.<IAIFFIOStrategy> = getSupportedStrategies();

        /*
        * You can add extra strategies here.
        *
        * Lowest index: Most expected
        * Highest index: Less expected
        */
        private static function getSupportedStrategies() : Vector.<IAIFFIOStrategy>
        {
            const strategies: Vector.<IAIFFIOStrategy> = new Vector.<IAIFFIOStrategy>( 4, true );

            strategies[0] = AIFF16BitStereo44Khz.INSTANCE;
            strategies[1] = AIFF24BitStereo44Khz.INSTANCE;
            strategies[2] = AIFF32BitStereo44Khz.INSTANCE;
            strategies[3] = AIFF8BitStereo44Khz.INSTANCE;

            return strategies;
        }

        private var _numSamples: Number;
        private var _dataOffset: Number;
        private var _blockAlign: uint;

        public function AIFFDecoder( bytes: ByteArray )
        {
            super( bytes, evaluateHeader( bytes ) );
        }

        override public function get numSamples(): Number
        {
            return _numSamples;
        }

        override public function get dataOffset(): Number
        {
            return _dataOffset;
        }

        override public function get blockAlign(): int
        {
            return _blockAlign;
        }

        private function evaluateHeader( bytes: ByteArray ) : IPCMIOStrategy
        {
            const info: FormatInfo = parseHeader( bytes );

            const n : int = STRATEGIES.length;

            for( var i: int = 0 ; i < n ; ++i )
            {
                var strategy: IAIFFIOStrategy = STRATEGIES[i];

                if ( strategy.supports( info ) )
                {
                    return strategy;
                }
            }

            return null;
        }
    }
}