/*
    struct sfPresetHeader
    {
        CHAR achPresetName[20];
        WORD wPreset;
        WORD wBank;
        WORD wPresetBagNdx;
        DWORD dwLibrary;
        DWORD dwGenre;
        DWORD dwMorphology;
    };

    The ASCII character field achPresetName contains the name of the preset expressed in ASCII, with unused
    terminal characters filled with zero valued bytes. Preset names are case sensitive. A unique name should
    always be assigned to each preset in the SoundFont compatible bank to enable identification. However, if a
    bank is read containing the erroneous state of presets with identical names, the presets should not be
    discarded. They should either be preserved as read or preferably uniquely renamed.

    The WORD wPreset contains the MIDI Preset Number and the WORD wBank contains the MIDI Bank Number which
    apply to this preset. Note that the presets are not ordered within the SoundFont compatible bank. Presets
    should have a unique set of wPreset and wBank numbers. However, if two presets have identical values of both
    wPreset and wBank, the first occurring preset in the PHDR chunk is the active preset, but any others with
    the same wBank and wPreset values should be maintained so that they can be renumbered and used at a later
    time. The special case of a General MIDI percussion bank is handled conventionally by a wBank value of 128.
    If the value in either field is not a valid MIDI value of zero through 127, or 128 for wBank, the preset
    cannot be played but should be maintained.

    The WORD wPresetBagNdx is an index to the preset’s zone list in the PBAG sub-chunk. Because the preset zone
    list is in the same order as the preset header list, the preset bag indices will be monotonically increasing
    with increasing preset headers. The size of the PBAG sub-chunk in bytes will be equal to four times the
    terminal preset’s wPresetBagNdx plus four. If the preset bag indices are non-monotonic or if the terminal
    preset’s wPresetBagNdx does not match the PBAG sub-chunk size, the file is structurally defective and should
    be rejected at load time. All presets except the terminal preset must have at least one zone; any preset with
    no zones should be ignored.

    The DWORDs dwLibrary, dwGenre and dwMorphology are reserved for future implementation in a preset library
    management function and should be preserved as read, and created as zero.
*/

package com.ferretgodmother.soundfont.chunks.data
{
    public class PresetRecord extends ZoneRecord
    {
        public var preset:int;
        public var bank:int;
        // These next 3 are unused in the SoundFont 2.1 Specification:
        public var library:uint;
        public var genre:uint;
        public var morphology:uint;

        public function PresetRecord()
        {
            super("PresetRecord");
        }
    }
}
