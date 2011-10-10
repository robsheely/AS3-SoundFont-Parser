package tonfall.prefab.metronome
{
	import tonfall.core.BlockInfo;
	import tonfall.core.Processor;

	/**
	 * Metronome Sequencer sends event every beat.
	 * 
	 * @author Andre Michelle
	 */
	public final class MetronomeSequencer extends Processor
	{
		private var _timeEventTarget: Processor;
		
		private var _upper: int = 4;
		private var _lower: int = 4;
		
		public function MetronomeSequencer() {}

		override public function process( info: BlockInfo ) : void
		{
			if( null == _timeEventTarget )
				throw new Error( 'No event target defined.' );
			
			var position:Number = int( info.barFrom * _lower ) / _lower;

			var beat:int;
			var bar:int;

			var event: MetronomeEvent;

			do
			{
				if( position >= info.barFrom )
				{
					beat = position * _lower;
					bar  = int( beat / _upper );
					beat %= _upper;

					event = new MetronomeEvent();
					event.bar = position;
					event.bar = bar;
					event.beat = beat;

					_timeEventTarget.addTimeEvent( event );
				}

				position += 1.0 / _lower;
			}
			while( position < info.barTo );
		}

		public function get upper() : int
		{
			return _upper;
		}

		public function set upper( value: int ) : void
		{
			_upper = value;
		}

		public function get lower() : int
		{
			return _lower;
		}

		public function set lower( value: int ) : void
		{
			_lower = value;
		}

		public function get timeEventTarget() : Processor
		{
			return _timeEventTarget;
		}

		public function set timeEventTarget( target: Processor ) : void
		{
			_timeEventTarget = target;
		}
	}
}