package com.ferretgodmother.soundfont.demo
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import mx.controls.Alert;

    import com.ferretgodmother.soundfont.Preset;
    import com.ferretgodmother.soundfont.chunks.SoundFontChunk;
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;
    import com.ferretgodmother.soundfont.chunks.info.InfoChunk;

    import deng.fzip.FZip;

    import tonfall.format.wav.WAVTags;

    public class WavExporter extends EventDispatcher
    {
        protected var _fileRef:FileReference;

        public function exportSamples(soundFontChunk:SoundFontChunk):void
        {
            _fileRef = new FileReference();
            _fileRef.addEventListener(IOErrorEvent.IO_ERROR, fileRef_onIOError);
            _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileRef_onSecurityError);
            _fileRef.addEventListener(Event.SELECT, fileRef_onSelect);
            var zip:FZip = new FZip();
            for each (var record:SampleRecord in soundFontChunk.sampleRecords)
            {
                var bytes:ByteArray = writeSample(record.sampleData);
                zip.addFile(record.name + ".wav", bytes, true);
            }
            bytes = new ByteArray();
            zip.serialize(bytes, true);
            bytes.position = 0;
            var properties:Object = soundFontChunk.infoChunk.properties;
            var bankName:String = (properties.hasOwnProperty("bankName")) ? properties["bankName"] : "SoundFont";
            _fileRef.save(bytes, bankName + ' samples.zip');
        }

        protected function writeSample(sampleData:ByteArray):ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.writeUnsignedInt(WAVTags.RIFF);
            bytes.writeUnsignedInt(sampleData.length + 36);
            bytes.writeUnsignedInt(WAVTags.WAVE);
            bytes.writeUnsignedInt(WAVTags.FMT);
            bytes.writeUnsignedInt(16); // chunk length
            bytes.writeShort(1); // compression
            bytes.writeShort(1); // numChannels
            bytes.writeUnsignedInt(44100); // samplingRate
            bytes.writeUnsignedInt(88200); // bytesPerSecond
            bytes.writeShort(2); // blockAlign
            bytes.writeShort(16); // bits
            bytes.writeUnsignedInt(WAVTags.DATA);
            bytes.writeUnsignedInt(sampleData.length);
            bytes.writeBytes(sampleData);
            return bytes;
        }

        protected function fileRef_onSelect(event:Event):void
        {
            _fileRef.addEventListener(ProgressEvent.PROGRESS, fileRef_onProgress);
            _fileRef.addEventListener(Event.COMPLETE, fileRef_onComplete);
            _fileRef.addEventListener(Event.CANCEL, fileRef_onCancel);
        }

        protected function fileRef_onProgress(event:ProgressEvent):void
        {
            //trace("Saved " + event.bytesLoaded + " of " + event.bytesTotal + " bytes.");
        }

        protected function fileRef_onComplete(event:Event):void
        {
            _fileRef.removeEventListener(Event.SELECT, fileRef_onSelect);
            _fileRef.removeEventListener(ProgressEvent.PROGRESS, fileRef_onProgress);
            _fileRef.removeEventListener(Event.COMPLETE, fileRef_onComplete);
            _fileRef.removeEventListener(Event.CANCEL, fileRef_onCancel);
        }

        protected function fileRef_onCancel(event:Event):void
        {
            //trace("The save request was canceled by the user.");
        }

        protected function fileRef_onIOError(event:IOErrorEvent):void
        {
            Alert.show("There was an error while trying to save file.", "Error");
        }

        protected function fileRef_onSecurityError(event:Event):void
        {
            Alert.show("There was a security error while trying to save file.", "Error");
        }

        protected function dispatchFailedEvent():void
        {
            dispatchEvent(new Event("failed"));
        }
    }
}
