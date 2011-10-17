/**
 * SFObject is the base class for all objects in SoundFont Parser. It provides methods to serialize the object to XML,
 * raise errors, and get a string representation of the object.
 */
package com.ferretgodmother.soundfont
{
    import flash.utils.describeType;

    public class SFObject
    {
        private static const NON_SERIALIZABLE_TYPES:Array = ["ByteArray", "SFByteArray"];
        /**
        * Used by the raiseError() method for determining how to respond to raised errors.
         */
        public static var errorReportingMethod:String = "trace";
        /**
         * An array of property names to omit from the XML serialization of the object.
         */
        protected var nonSerializedProperties:Array = ["type", "nonSerializedProperties"];
        /**
         * The name of the object (usually the class name).
         */
        public var type:String;

        public function SFObject(type:String)
        {
            this.type = type;
        }

        public function get propertyNames():Array
        {
            return [ ];
        }

        public function toString():String
        {
            return toXML().toXMLString();
        }

        /**
         * Uses flash.utils.describeType to get a list of all public properties (both vars and accessors) of this object,
         * the produces an XML representation of the object.
         */
        public function toXML():XML
        {
            var xml:XML = new XML("<" + type + "/>");
            var propertyNames:Array = getPropertyNames(true);
            for each (var propertyName:String in propertyNames)
            {
                if (includePropertyInSerialization(propertyName))
                {
                    if (this[propertyName] is Boolean)
                    {
                        xml.@[propertyName] = this[propertyName].toString();
                    }
                    else if (this[propertyName] is SFObject)
                    {
                        var objectXML:XML = this[propertyName].toXML();
                        xml.appendChild(objectXML);
                    }
                    else if (this[propertyName] is Array)
                    {
                        if (this[propertyName].length > 0 && this[propertyName][0] is SFObject)
                        {
                            var childXML:XML = new XML("<" + propertyName + "/>");
                            for (var i:int = 0; i < this[propertyName].length; ++i)
                            {
                                childXML.appendChild(this[propertyName][i].toXML());
                            }
                            xml.appendChild(childXML);
                        }
                    }
                    else
                    {
                        xml.@[propertyName] = this[propertyName];
                    }
                }
            }
            return xml;
        }

        /**
         * A method to allow subclasses to define criteria for including or exclusing particular properties from XML
         * serialization.
         */
        protected function includePropertyInSerialization(propertyName:String):Boolean
        {
            return this[propertyName] != null;
        }

        /**
         * A method to allow subclasses to get a list of property names for this object. Used in XML serialization. Also
         * used in Zone and NoteSample (and their subclasses) to construct the DEFAULTS object.
         */
        protected function getPropertyNames(includeAccessors:Boolean = true):Array
        {
            var classInfo:XML = describeType(this);
            var properties:XMLList = classInfo..variable;
            if (includeAccessors)
            {
                properties += classInfo..accessor.(@access != "writeonly");
            }
            var propertyNames:Array = [];
            for each (var propertyXML:XML in properties)
            {
                if (SFObject.NON_SERIALIZABLE_TYPES.indexOf(propertyXML.@type.toString()) == -1 && this.nonSerializedProperties.
                    indexOf(propertyXML.@name.toString()) == -1)
                {
                    propertyNames.push(propertyXML.@name.toString());
                }
            }
            return propertyNames;
        }

        /**
         * A simple method for dealing with errors. Allows you to set the method to "trace" or "error."
         */
        protected function raiseError(message:String):void
        {
            switch (errorReportingMethod)
            {
                case "trace":
                {
                    trace(message);
                    break;
                }
                case "error":
                {
                    throw new Error(message);
                    break;
                }
            }
        }
    }
}
