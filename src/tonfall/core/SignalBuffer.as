package tonfall.core
{

    /**
     * Stereo audio data linked list (looped)
     *
     * @author Andre Michelle
     */
    public final class SignalBuffer
    {
        private var _current:Signal;
        private var _currentIndex:int;
        private var _size:int;
        private var _vector:Vector.<Signal>;

        /**
         * @param size The size of the buffer to be created. If a negative value or zero is passed, the default blockSize is used.
         *
         * @see Signal
         * @see blockSize
         */
        public function SignalBuffer(size:int = 0)
        {
            init(0 >= size ? blockSize : size);
        }

        /**
         * @return The current signal within the block
         */
        public function get current():Signal
        {
            return _current;
        }

        /**
         * Sets 'num' signals to zero (silent), beginning with internal current signal
         *
         * @param num How many signals needs to be set to zero
         */
        public function zero(num:int):void
        {
            var signal:Signal = _current;
            for (var i:int = 0; i < num; ++i)
            {
                signal.l = signal.r = 0.0;
                signal = signal.next;
            }
        }

        /**
         * Multiply 'num' signals by gain, beginning with internal current signal
         *
         * @param num How many signals to be multiplied
         * @param gain The factor to be multiplied
         */
        public function multiply(num:int, gain:Number):void
        {
            var signal:Signal = _current;
            for (var i:int = 0; i < num; ++i)
            {
                signal.l *= gain;
                signal.r *= gain;
                signal = signal.next;
            }
        }

        /**
         * @param index The index where to find the signal (wraps index)
         * @return A signal inside the buffer
         *
         * @see Signal
         */
        public function getSignalAt(index:int):Signal
        {
            if (index < 0)
            {
                index += _size;
            }
            else if (index >= _size)
            {
                index -= _size;
            }
            return _vector[index];
        }

        /**
         * @param delta The offset of signals counting from currentIndex (wraps index)
         * @return The Signal at this offset
         */
        public function deltaPointer(delta:int):Signal
        {
            var index:int = _currentIndex + delta;
            if (index < 0)
            {
                index += _size;
            }
            else if (index >= _size)
            {
                index -= _size;
            }
            return _vector[index];
        }

        /**
         * Advance internal currentIndex
         *
         * @param count The number of signals to advance (wraps index)
         */
        public function advancePointer(count:int):void
        {
            if (0 == count)
            {
                return;
            }
            _currentIndex += count;
            if (_currentIndex < 0)
            {
                _currentIndex += _size;
            }
            else if (_currentIndex >= _size)
            {
                _currentIndex -= _size;
            }
            _current = _vector[_currentIndex];
        }

        /**
         * @return The vector of signals
         */
        public function get vector():Vector.<Signal>
        {
            return _vector;
        }

        private function init(length:int):void
        {
            var head:Signal;
            var tail:Signal;
            _vector = new Vector.<Signal>(length, true);
            tail = head = _vector[0] = new Signal();
            for (var i:int = 1; i < length; ++i)
            {
                tail = tail.next = _vector[i] = new Signal();
            }
            _current = tail.next = head;
            _currentIndex = 0;
            _size = length;
        }
    }
}
