package tonfall.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.media.SoundMixer;
    import flash.utils.ByteArray;
    import tonfall.core.Driver;

    /**
     * Spectrum is a fast and imprecise debug view of the audio data.
     *
     * @author Andre Michelle
     */
    public final class Spectrum extends Sprite
    {
        private const BACKGROUND:uint = 0x333333;
        private const WIDTH:int = 352;
        private const HEIGHT:int = 304;

        private const driver:Driver = Driver.getInstance();
        private const bitmapWaveform:Bitmap = new Bitmap(new BitmapData(0x100, 0x80, false, 0x333333), PixelSnapping.ALWAYS);
        private const bitmapSpectrum:Bitmap = new Bitmap(new BitmapData(0x100, 0x80, false, 0x333333), PixelSnapping.ALWAYS);
        private const bitmapPeaksLeft:Bitmap = new Bitmap(new BitmapData(16, 272, false, 0x333333), PixelSnapping.ALWAYS);
        private const bitmapPeaksRight:Bitmap = new Bitmap(new BitmapData(16, 272, false, 0x333333), PixelSnapping.ALWAYS);
        private const outputArray:ByteArray = new ByteArray();
        private const rectLine:Rectangle = new Rectangle(0.0, 0.0, 1.0, 0.0);
        private const rectPeak:Rectangle = new Rectangle(0.0, 0.0, 16.0, 0.0);

        public function Spectrum()
        {
            graphics.beginFill(0x222222);
            graphics.drawRoundRect(0.0, 0.0, WIDTH, HEIGHT, 8.0, 8.0);
            graphics.endFill();
            bitmapWaveform.x = 16.0;
            bitmapWaveform.y = 16.0;
            addChild(bitmapWaveform);
            bitmapSpectrum.x = 16.0;
            bitmapSpectrum.y = 160.0;
            addChild(bitmapSpectrum);
            bitmapPeaksLeft.x = 288.0;
            bitmapPeaksLeft.y = 16.0;
            addChild(bitmapPeaksLeft);
            bitmapPeaksRight.x = 320.0;
            bitmapPeaksRight.y = 16.0;
            addChild(bitmapPeaksRight);
            addEventListener(Event.ADDED_TO_STAGE, added);
            addEventListener(Event.REMOVED_FROM_STAGE, removed);
        }

        override public function get width():Number
        {
            return WIDTH;
        }

        override public function get height():Number
        {
            return HEIGHT;
        }

        public function dispose():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, added);
            removeEventListener(Event.REMOVED_FROM_STAGE, removed);
        }

        private function enterFrame(event:Event):void
        {
            paintWaveform();
            paintSpectrum();
            paintPeak(bitmapPeaksLeft.bitmapData, driver.leftPeak);
            paintPeak(bitmapPeaksRight.bitmapData, driver.rightPeak);
        }

        private function paintWaveform():void
        {
            const bitmapData:BitmapData = bitmapWaveform.bitmapData;
            bitmapData.lock();
            bitmapData.fillRect(bitmapData.rect, BACKGROUND);
            SoundMixer.computeSpectrum(outputArray, false);
            var l:Number;
            var r:Number;
            for (var x:int = 0; x < 0x100; ++x)
            {
                outputArray.position = x << 2;
                l = outputArray.readFloat();
                outputArray.position = (x | 0x100) << 2;
                r = outputArray.readFloat();
                bitmapData.setPixel(x, 0x40 + l * 0x40, 0xAAAAAA);
                bitmapData.setPixel(x, 0x40 + r * 0x40, 0xCCCCCC);
            }
            bitmapData.unlock();
        }

        private function paintSpectrum():void
        {
            const bitmapData:BitmapData = bitmapSpectrum.bitmapData;
            bitmapData.lock();
            bitmapData.fillRect(bitmapData.rect, BACKGROUND);
            SoundMixer.computeSpectrum(outputArray, true, 1);
            var l:Number;
            var r:Number;
            var h:int;
            for (var x:int = 0; x < 0x100; ++x)
            {
                outputArray.position = x << 2;
                l = outputArray.readFloat();
                outputArray.position = (x | 0x100) << 2;
                r = outputArray.readFloat();
                h = (l > r ? l : r) * 0x80;
                rectLine.x = x;
                rectLine.y = 0x80 - h;
                rectLine.height = h;
                bitmapData.fillRect(rectLine, 0xAAAAAA);
            }
            bitmapData.unlock();
        }

        private function paintPeak(bitmapData:BitmapData, peak:Number):void
        {
            bitmapData.lock();
            var yy:int = (1.0 - peak) * 272.0;
            rectPeak.y = 0.0;
            rectPeak.height = yy;
            bitmapData.fillRect(rectPeak, BACKGROUND);
            rectPeak.y = yy;
            rectPeak.height = 272.0 - yy;
            bitmapData.fillRect(rectPeak, 0xAAAAAA);
            bitmapData.unlock();
        }

        private function added(event:Event):void
        {
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }

        private function removed(event:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, enterFrame);
        }
    }
}