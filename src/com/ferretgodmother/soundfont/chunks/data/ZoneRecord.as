package com.ferretgodmother.soundfont.chunks.data
{
    import com.ferretgodmother.soundfont.SFObject;

    public class ZoneRecord extends SFObject
    {
        public var id:int;
        public var name:String;
        public var index:int;
        public var generators:Array = [ ];
        public var modulators:Array = [ ];

        public function ZoneRecord(type:String)
        {
            super(type);
            this.nonSerializedProperties.push("generators", "moderators");
        }

        public function addGenerator(generator:GeneratorRecord):void
        {
            this.generators.push(generator);
        }

        public function addModulatator(modulator:ModulatorRecord):void
        {
            this.modulators.push(modulator);
        }
    }
}
