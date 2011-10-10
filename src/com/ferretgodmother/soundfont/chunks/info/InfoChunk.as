/*
    The INFO-list chunk in a SoundFont 2 compatible file contains three mandatory and a variety of optional sub-chunks.
    The INFO-list chunk gives basic information about the SoundFont compatible bank that is contained in the file.
*/
package com.ferretgodmother.soundfont.chunks.info
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.chunks.Chunk;

    public class InfoChunk extends Chunk
    {
        public static const INFO_TAG:String = "INFO";
        public static const RIFF_VERSION_TAG:String = "ifil";
        public static const TARGET_ENGINE_TAG:String = "isng";
        public static const BANK_NAME_TAG:String = "INAM";
        public static const ROM_NAME_TAG:String = "irom";
        public static const ROM_VERSION_TAG:String = "iver";
        public static const CREATION_DATE_TAG:String = "ICRD";
        public static const ENGINEERS_TAG:String = "IENG";
        public static const PRODUCT_TAG:String = "IPRD";
        public static const COPYRIGHT_TAG:String = "ICOP";
        public static const COMMENTS_TAG:String = "ICMT";
        public static const TOOLS_TAG:String = "ISFT";

        public var properties:Object = { };

        public function InfoChunk(source:SFByteArray = null)
        {
            super("InfoChunk", source);
        }

        override public function parse(value:SFByteArray):void
        {
            while (value.bytesAvailable > 0)
            {
                _format = value.readString(4);
                _chunkSize = value.readDWord();
                switch (_format)
                {
                    case RIFF_VERSION_TAG:
                    {
                        var version:Object =
                        {
                            major: value.readWord(),
                            minor: value.readWord()
                        };
                        properties["version"] = version;
                        break;
                    }
                    case ROM_VERSION_TAG:
                    {
                        var romVersion:Object =
                        {
                            major: value.readWord(),
                            minor: value.readWord()
                        };
                        properties["romVersion"] = romVersion;
                        break;
                    }
                    case TARGET_ENGINE_TAG:
                    {
                        properties["targetEngine"] = value.readString(_chunkSize);
                        break;
                    }
                    case BANK_NAME_TAG:
                    {
                        properties["bankName"] = value.readString(_chunkSize);
                        break;
                    }
                    case ROM_NAME_TAG:
                    {
                        properties["romName"] = value.readString(_chunkSize);
                        break;
                    }
                    case CREATION_DATE_TAG:
                    {
                        properties["creationDate"] = value.readString(_chunkSize);
                        break;
                    }
                    case ENGINEERS_TAG:
                    {
                        properties["engineers"] = value.readString(_chunkSize);
                        break;
                    }
                    case PRODUCT_TAG:
                    {
                        properties["product"] = value.readString(_chunkSize);
                        break;
                    }
                    case COPYRIGHT_TAG:
                    {
                        properties["copyright"] = value.readString(_chunkSize);
                        break;
                    }
                    case COMMENTS_TAG:
                    {
                        properties["comments"] = value.readString(_chunkSize);
                        break;
                    }
                    case TOOLS_TAG:
                    {
                        properties["tools"] = value.readString(_chunkSize);
                        break;
                    }
                    // If we find a "LIST" tag, we've gone too far. So we need to set the byteArray position
                    // back and then scram.
                    case Chunk.LIST_TAG:
                    {
                        value.position -= 8;
                        return;
                        break;
                    }
                    default:
                    {
                        raiseError("Info::set bytes: Unrecognized tag! format: " + _format);
                        break;
                    }
                }
            }
        }
    }
}
