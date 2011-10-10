package tonfall.display
{
	import tonfall.core.IParameterObserver;
	import tonfall.core.Parameter;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Very simple static slider to control Parameter
	 * 
	 * @author Andre Michelle
	 * @see Parameter
	 */
	public final class ParameterSlider extends Sprite
		implements IParameterObserver
	{
		private static const TEXT_FORMAT : TextFormat = new TextFormat( 'Verdana', 9, 0, true );
		
		private const textField : TextField = new TextField();
		private const thumb: Thumb = new Thumb();
		
		private var _parameter : Parameter;
		
		private var _dragging: Boolean;
		private var _dragOffset : Number = 0.0;

		public function ParameterSlider( parameter: Parameter )
		{
			_parameter = parameter;
			_parameter.addObserver( this );
			
			init();
		}
		
		public function onParameterChanged( parameter: Parameter ): void
		{
			updateView();
		}

		private function init() : void
		{
			graphics.beginFill( 0xFFFFFF );
			graphics.drawRoundRect( 0.0, 0.0, 288.0, 24.0, 4.0, 4.0 );
			graphics.endFill();
			graphics.beginFill( 0x333333 );
			graphics.drawRect( 4.0, 4.0, 192.0, 16.0 );
			graphics.endFill();

			textField.defaultTextFormat = TEXT_FORMAT;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = 204;
			textField.y = 6.0;

			thumb.y = 4.0;

			addChild( textField );
			addChild( thumb );
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			
			updateView();
		}

		private function mouseDown( event : MouseEvent ) : void
		{
			_dragging = true;
			
			_dragOffset = event.target == thumb ? thumb.mouseX - 4.0 : 0.0;
			
			update( mouseX );
			
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		
		private function mouseMove( event : MouseEvent ) : void
		{
			if( _dragging )
			{
				update( mouseX );
			}
		}
		
		private function mouseUp( event : MouseEvent ) : void
		{
			if( _dragging )
			{
				stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
				
				_dragging = false;
			}
		}
		
		private function update( x: Number ): void
		{
			var value: Number = ( ( x - _dragOffset ) - 16.0 ) / 176.0;

			if( value < 0.0 )
				value = 0.0;
			else
			if( value > 1.0 )
				value = 1.0;
			
			_parameter.value = value;
		}
		
		private function updateView(): void
		{
			var value: Number = _parameter.value;
			
			thumb.x = 4.0 + value * 176.0;

			textField.text = _parameter.name + ' ' + Math.round( value * 100.0 ) + '%';
		}
	}
}
import flash.display.Sprite;

class Thumb extends Sprite
{
	public function Thumb()
	{
		graphics.beginFill( 0xCCCCCC );
		graphics.drawRect( 0.0, 0.0, 16.0, 16.0 );
		graphics.endFill();
		
		buttonMode = true;
		useHandCursor = true;
		cacheAsBitmap = true;
	}
}