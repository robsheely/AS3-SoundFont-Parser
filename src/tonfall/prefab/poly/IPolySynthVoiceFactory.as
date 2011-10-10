package tonfall.prefab.poly
{
	import tonfall.core.TimeEventNote;
	
	/**
	 * Creates an IPolySynthVoice
	 * @author Andre Michelle
	 */
	public interface IPolySynthVoiceFactory
	{
		function create( event: TimeEventNote ): IPolySynthVoice;
	}
}
