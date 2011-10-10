/*
    The RIFF (Resource Interchange File Format) is a tagged file structure developed for multimedia resource files,
    and is described in some detail in the Microsoft Windows SDK Multimedia Programmer’s Reference. The tagged-file
    structure is useful because it helps prevent compatibility problems which can occur as the file definition changes
    over time. Because each piece of data in the file is identified by a standard header, an application that does
    not recognize a given data element can skip over the unknown information.

    A RIFF file is constructed from a basic building block called a “chunk.” In ‘C’ syntax, a chunk is defined:

    typedef DWORD FOURCC;    // Four-character code

    typedef struct
    {
        FOURCC DWORD BYTE
        ckID;    // A chunk ID identifies the type of data within the chunk.
        ckSize;    // The size of the chunk data in bytes, excluding any pad byte.
        ckDATA[ckSize];    // The actual data plus a pad byte if req’d to word align.
    };
    Two types of chunks, the “RIFF” and “LIST” chunks, may contain nested chunks called sub-chunks as their data.
*/
package com.ferretgodmother.soundfont.chunks
{
    import com.ferretgodmother.soundfont.utils.SFByteArray;
    import com.ferretgodmother.soundfont.SFObject;

    public class Chunk extends SFObject
    {
        public static const RIFF_TAG:String = "RIFF";
        public static const LIST_TAG:String = "LIST";

        protected var _format:String;
        protected var _chunkSize:uint;

        public function Chunk(type:String, source:SFByteArray = null)
        {
            super(type);
            if (source != null)
            {
                parse(source);
            }
        }

        public function parse(value:SFByteArray):void
        {
            // ABSTRACT
        }
    }
}
