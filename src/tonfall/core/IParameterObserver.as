package tonfall.core
{
    /**
     * @author Andre Michelle
     */
    public interface IParameterObserver
    {
        function onParameterChanged(parameter:Parameter):void;
    }
}
