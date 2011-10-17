/*
Utility to extract the sample waveform data from a SoundFont, compress them into a zip archive and save them to disk.
*/
package com.ferretgodmother.soundfont.utils
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    import com.ferretgodmother.soundfont.chunks.SoundFontChunk;
    import com.ferretgodmother.soundfont.chunks.data.SampleRecord;

    import deng.fzip.FZip;

    [Event(name="error", type="flash.events.ErrorEvent")]
    public class WavExporter extends EventDispatcher
    {
        protected var _fileRef:FileReference = new FileReference();

        public function WavExporter()
        {
            _fileRef.addEventListener(IOErrorEvent.IO_ERROR, fileRef_onIOError);
            _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileRef_onSecurityError);
            _fileRef.addEventListener(Event.SELECT, fileRef_onSelect);
            _fileRef.addEventListener(Event.CANCEL, fileRef_onCancel);
        }

        public function exportSamples(soundFontChunk:SoundFontChunk):void
        {
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

        // SoundFont waveform data is in PCM format which is essentially a wav with out the wav header. This function
        // constructs the header, adds the waveform data and returns the resulting byteArray.
        protected function writeSample(sampleData:ByteArray):ByteArray
        {
            // This code is a modification of code from the tonfall engine. (http://code.google.com/p/tonfall/)
            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            // Add header bytes
            bytes.writeUnsignedInt(0x46464952); // RIFF
            bytes.writeUnsignedInt(sampleData.length + 36); // file length minus the 4 bytes of "RIFF"
            bytes.writeUnsignedInt(0x45564157); // WAVE
            bytes.writeUnsignedInt(0x20746D66); // FMT
            bytes.writeUnsignedInt(16); // chunk length
            bytes.writeShort(1); // compression
            bytes.writeShort(1); // numChannels
            bytes.writeUnsignedInt(44100); // samplingRate
            bytes.writeUnsignedInt(88200); // bytesPerSecond
            bytes.writeShort(2); // blockAlign
            bytes.writeShort(16); // bits
            bytes.writeUnsignedInt(0x61746164); // DATA
            bytes.writeUnsignedInt(sampleData.length); // data length
            // Add waveform data bytes
            bytes.writeBytes(sampleData);
            return bytes;
        }

        protected function fileRef_onSelect(event:Event):void
        {
            _fileRef.addEventListener(ProgressEvent.PROGRESS, fileRef_onProgress);
            _fileRef.addEventListener(Event.COMPLETE, fileRef_onComplete);
        }

        protected function fileRef_onProgress(event:ProgressEvent):void
        {
            //trace("Saved " + event.bytesLoaded + " of " + event.bytesTotal + " bytes.");
        }

        protected function fileRef_onComplete(event:Event):void
        {
            //trace("The samples were saved successfully.");
            _fileRef.removeEventListener(ProgressEvent.PROGRESS, fileRef_onProgress);
            _fileRef.removeEventListener(Event.COMPLETE, fileRef_onComplete);
        }

        protected function fileRef_onCancel(event:Event):void
        {
            //trace("The save request was canceled by the user.");
        }

        protected function fileRef_onIOError(event:IOErrorEvent):void
        {
            dispatchErrorEvent("There was an error while saving samples.");
        }

        protected function fileRef_onSecurityError(event:Event):void
        {
            dispatchErrorEvent("There was a security error while saving samples.");
        }

        protected function dispatchErrorEvent(text:String):void
        {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, text));
        }
    }
}
