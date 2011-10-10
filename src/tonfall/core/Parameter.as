package tonfall.core
{
    /**
     * Parameter stores a normalized value for external controlling
     *
     * @author Andre Michelle
     */
    public final class Parameter
    {
        private const observers:Vector.<IParameterObserver> = new Vector.<IParameterObserver>();

        private var _name:String;
        private var _value:Number;

        public function Parameter(name:String, value:Number = 0.0)
        {
            _name = name;
            _value = value;
        }

        public function get name():String
        {
            return _name;
        }

        public function get value():Number
        {
            return _value;
        }

        public function set value(value:Number):void
        {
            if (_value != value)
            {
                _value = value;
                // NOTIFY
                var i:int = observers.length;
                while (--i > -1)
                {
                    observers[i].onParameterChanged(this);
                }
            }
        }

        public function addObserver(observer:IParameterObserver):void
        {
            if (-1 == observers.indexOf(observer))
            {
                observers.push(observer);
            }
        }

        public function removeObserver(observer:IParameterObserver):void
        {
            const deleteIndex:int = observers.indexOf(observer);
            if (-1 < deleteIndex)
            {
                observers.splice(deleteIndex, 1);
            }
        }
    }
}
