package tonfall.format.midi 
{

	/**
	 * @author Andre Michelle
	 */
	public class MidiEventString 
	{
		static public const NAME_NOTE_ON: String = 'Note On';
		static public const NAME_NOTE_OFF: String = 'Note Off';
		static public const NAME_NOTE_AFTERTOUCH: String = 'Note Aftertouch';
		static public const NAME_CONTROLLER: String = 'Controller';
		static public const NAME_PROGRAM_CHANGE: String = 'Program Change';
		static public const NAME_AFTERTOUCH: String = 'Aftertouch';
		static public const NAME_PITCH_BEND: String = 'Pitch Bend';
		static public const NAME_UNKNOWN: String = 'Unknown';

		static public function getString( event: MidiChannelEvent ): String
		{
			var type: int = event.type;
			
			switch( type )
			{
				case 0x80:

					return NAME_NOTE_OFF;

				case 0x90:

					return NAME_NOTE_ON;

				case 0xa0:
				
					return NAME_NOTE_AFTERTOUCH;
				
				case 0xb0:
				
					return NAME_CONTROLLER;
				
				case 0xc0:
				
					return NAME_PROGRAM_CHANGE;
				
				case 0xd0:
				
					return NAME_AFTERTOUCH;
				
				case 0xe0:

					return NAME_PITCH_BEND;
				
				default:
				
					return NAME_UNKNOWN;
			}
			
			return null;
		}
	}
}
