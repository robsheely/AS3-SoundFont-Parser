package com.ferretgodmother.soundfont.demo.assets
{
    import tonfall.format.midi.MidiFormat;

    /**
    * @author Andre Michelle
    */
    public final class Midi
    {
        // Kreisleriana, Opus 16 (1838) - Robert Schumann
        [ Embed( source='schumann.mid', mimeType='application/octet-stream' ) ]
            private static const SCHUMANN_CLASS: Class;

        public static const SCHUMANN: MidiFormat = MidiFormat.decode( new SCHUMANN_CLASS() );

        // Unknown author
        [ Embed( source='BBtheme.mid', mimeType='application/octet-stream' ) ]
            private static const BUBBLE_BOBBLE_CLASS: Class;

        public static const BUBBLE_BOBBLE: MidiFormat = MidiFormat.decode( new BUBBLE_BOBBLE_CLASS() );
    }
}
