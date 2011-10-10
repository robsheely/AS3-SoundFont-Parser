package tonfall.dsp
{
    import tonfall.core.Signal;
    import tonfall.math.sinh;

    /**
     * http://www.drdobbs.com/184401931?pgno=12
     *
     * @author Andre Michelle
     */
    public final class BiQuadFilter
    {
        public var a0:Number;
        public var a1:Number;
        public var a2:Number;
        public var a3:Number;
        public var a4:Number;
        public var x1l:Number;
        public var x2l:Number;
        public var y1l:Number;
        public var y2l:Number;
        public var x1r:Number;
        public var x2r:Number;
        public var y1r:Number;
        public var y2r:Number;

        public function BiQuadFilter()
        {
            x1l = x2l = y1l = y2l = x1r = x2r = y1r = y2r = 0.0;
        }

        public function lowPass(fc:Number, fs:Number = 44100.0, bandwidth:Number = 1.0):void
        {
            const omega:Number = 2.0 * Math.PI * fc / fs;
            const sn:Number = Math.sin(omega);
            const cs:Number = Math.cos(omega);
            const alpha:Number = sn / (2.0 * bandwidth);
            const b0:Number = (1.0 - cs) / 2.0;
            const b1:Number = 1.0 - cs;
            const b2:Number = (1.0 - cs) / 2.0;
            const a0:Number = 1.0 + alpha;
            const a1:Number = -2.0 * cs;
            const a2:Number = 1.0 - alpha;
            this.a0 = b0 / a0;
            this.a1 = b1 / a0;
            this.a2 = b2 / a0;
            this.a3 = a1 / a0;
            this.a4 = a2 / a0;
        }

        public function highPass(fc:Number, fs:Number = 44100.0, bandwidth:Number = 1.0):void
        {
            const omega:Number = 2.0 * Math.PI * fc / fs;
            const sn:Number = Math.sin(omega);
            const cs:Number = Math.cos(omega);
            const alpha:Number = sn / (2.0 * bandwidth);
            const b0:Number = (1.0 + cs) / 2.0;
            const b1:Number = -(1.0 + cs);
            const b2:Number = (1.0 + cs) / 2.0;
            const a0:Number = 1.0 + alpha;
            const a1:Number = -2.0 * cs;
            const a2:Number = 1.0 - alpha;
            this.a0 = b0 / a0;
            this.a1 = b1 / a0;
            this.a2 = b2 / a0;
            this.a3 = a1 / a0;
            this.a4 = a2 / a0;
        }

        public function peakBand(dbGain:Number, fc:Number, fs:Number = 44100.0, bandwidth:Number = 1.0):void
        {
            const A:Number = Math.pow(10.0, dbGain / 40.0);
            const omega:Number = 2.0 * Math.PI * fc / fs;
            const sn:Number = Math.sin(omega);
            const cs:Number = Math.cos(omega);
            const alpha:Number = sn * sinh(Math.LN2 / 2.0 * bandwidth * omega / sn);
            const b0:Number = 1.0 + (alpha * A);
            const b1:Number = -2.0 * cs;
            const b2:Number = 1.0 - (alpha * A);
            const a0:Number = 1.0 + (alpha / A);
            const a1:Number = -2.0 * cs;
            const a2:Number = 1.0 - (alpha / A);
            this.a0 = b0 / a0;
            this.a1 = b1 / a0;
            this.a2 = b2 / a0;
            this.a3 = a1 / a0;
            this.a4 = a2 / a0;
        }

        public function lowShelf(dbGain:Number, fc:Number, fs:Number = 44100.0, shelfRate:Number = 1.414213562373095):void
        {
            const A:Number = Math.pow(10.0, dbGain / 40.0);
            const omega:Number = 2.0 * Math.PI * fc / fs;
            const sn:Number = Math.sin(omega);
            const cs:Number = Math.cos(omega);
            const alpha:Number = sn / 2.0 * Math.sqrt((A + 1.0 / A) * (1.0 / shelfRate - 1.0) + 2.0);
            const beta:Number = 2.0 * Math.sqrt(A) * alpha;
            const b0:Number = A * ((A + 1.0) - (A - 1.0) * cs + beta);
            const b1:Number = 2.0 * A * ((A - 1.0) - (A + 1.0) * cs);
            const b2:Number = A * ((A + 1.0) - (A - 1.0) * cs - beta);
            const a0:Number = (A + 1.0) + (A - 1.0) * cs + beta;
            const a1:Number = -2.0 * ((A - 1.0) + (A + 1.0) * cs);
            const a2:Number = (A + 1.0) + (A - 1.0) * cs - beta;
            this.a0 = b0 / a0;
            this.a1 = b1 / a0;
            this.a2 = b2 / a0;
            this.a3 = a1 / a0;
            this.a4 = a2 / a0;
        }

        public function highShelf(dbGain:Number, fc:Number, fs:Number = 44100.0, shelfRate:Number = 1.414213562373095):void
        {
            const A:Number = Math.pow(10.0, dbGain / 40.0);
            const omega:Number = 2.0 * Math.PI * fc / fs;
            const sn:Number = Math.sin(omega);
            const cs:Number = Math.cos(omega);
            const alpha:Number = sn / 2.0 * Math.sqrt((A + 1.0 / A) * (1.0 / shelfRate - 1.0) + 2.0);
            const beta:Number = 2.0 * Math.sqrt(A) * alpha;
            const b0:Number = A * ((A + 1.0) + (A - 1.0) * cs + beta);
            const b1:Number = -2.0 * A * ((A - 1.0) + (A + 1.0) * cs);
            const b2:Number = A * ((A + 1.0) + (A - 1.0) * cs - beta);
            const a0:Number = (A + 1.0) - (A - 1.0) * cs + beta;
            const a1:Number = 2.0 * ((A - 1.0) - (A + 1.0) * cs);
            const a2:Number = (A + 1.0) - (A - 1.0) * cs - beta;
            this.a0 = b0 / a0;
            this.a1 = b1 / a0;
            this.a2 = b2 / a0;
            this.a3 = a1 / a0;
            this.a4 = a2 / a0;
        }

        public function processSignal(signal:Signal):void
        {
            const li:Number = signal.l;
            const ri:Number = signal.r;
            const lf:Number = a0 * li + a1 * x1l + a2 * x2l - a3 * y1l - a4 * y2l;
            const rf:Number = a0 * ri + a1 * x1r + a2 * x2r - a3 * y1r - a4 * y2r;
            x2l = x1l;
            x1l = li;
            y2l = y1l;
            y1l = signal.l = lf;
            x2r = x1r;
            x1r = ri;
            y2r = y1r;
            y1r = signal.r = rf;
        }

        public function processSignals(signal:Signal, numSignals:int):void
        {
            var li:Number;
            var ri:Number;
            var lf:Number;
            var rf:Number;
            ++numSignals;
            while (--numSignals)
            {
                li = signal.l;
                ri = signal.r;
                lf = a0 * li + a1 * x1l + a2 * x2l - a3 * y1l - a4 * y2l;
                rf = a0 * ri + a1 * x1r + a2 * x2r - a3 * y1r - a4 * y2r;
                x2l = x1l;
                x1l = li;
                y2l = y1l;
                y1l = signal.l = lf;
                x2r = x1r;
                x1r = ri;
                y2r = y1r;
                y1r = signal.r = rf;
                signal = signal.next;
            }
        }

        public function toString():String
        {
            return '[Filter]';
        }
    }
}
