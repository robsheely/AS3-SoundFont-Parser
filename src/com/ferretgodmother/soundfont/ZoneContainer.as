/**
 * ZoneContainer is the base class for Preset and Instrument. It defines the common elements of these two classes. The
 * most important of these is the zones array which contains definitions for specified keyRange/velocityRange pairs.
 */
package com.ferretgodmother.soundfont
{
    import com.ferretgodmother.soundfont.chunks.data.ZoneRecord;
    import com.ferretgodmother.soundfont.chunks.data.GeneratorRecord;
    import com.ferretgodmother.soundfont.chunks.data.operators.Operator;
    import com.ferretgodmother.soundfont.chunks.data.operators.RangeOperator;

    public class ZoneContainer extends SFObject
    {
        /**
         * The lower-level data for this ZoneContainer. It contains the samples, generators and modulators which the
         * buildZones method uses to compile the zones for this container.
         */
        public var record:ZoneRecord;
        /**
         * The class which represents an individual zone in this container. (For Preset it is PresetZone. For Instrument
         * it is InstrumentZone.)
         */
        protected var _zoneClass:Class = Zone;
        /**
         * The "Global Zone" is a concept from the SoundFont specs. It represents the defaults for this particular
         * container.
         */
        protected var _globalZone:Zone;
        /**
         * An array containing the zones for this container. It is empty until the buildZones populates it.
         */
        protected var _zones:Array = [];

        public function ZoneContainer(type:String, record:ZoneRecord, zoneClass:Class)
        {
            super(type);
            this.nonSerializedProperties.push("record");
            _zoneClass = zoneClass;
            this.record = record;
        }

        public function get id():int
        {
            return this.record.id;
        }

        public function get name():String
        {
            return this.record.name;
        }

        public function get index():int
        {
            return this.record.index;
        }

        /**
         * Finds an zone that can play the specified key and velocity. If it can't find an exact match, it chooses the
         * closest non-match. KeyNum is the first priority and velocity is the tie-breaker.
         */
        public function getZone(keyNum:int, velocity:int):Zone
        {
            var closestVelDistance:int = 128;
            var closestKeyDistance:int = 128;
            var closestZone:Zone;
            for each (var zone:Zone in _zones)
            {
                if (zone.fits(keyNum, velocity))
                {
                    return zone;
                }
                var keyDistance:int = Math.abs(keyNum - zone.keyRange.low);
                keyDistance = Math.min(keyDistance, Math.abs(keyNum - zone.keyRange.high));
                var velDistance:int = Math.abs(velocity - zone.velRange.low);
                velDistance = Math.min(velDistance, Math.abs(velocity - zone.velRange.high));
                if (keyDistance < closestKeyDistance)
                {
                    closestKeyDistance = keyDistance;
                    closestVelDistance = velDistance;
                    closestZone = zone;
                }
                else if (keyDistance == closestKeyDistance)
                {
                    if (velDistance < closestVelDistance)
                    {
                        closestVelDistance = velDistance;
                        closestZone = zone;
                    }
                }
            }
            return closestZone;
        }

        /**
         * This method uses the samples, generators and modulators from the ZoneRecord data to populate the zones array.
         */
        public function buildZones(records:Array):void
        {
            for each (var generator:GeneratorRecord in this.record.generators)
            {
                buildZone(generator, records);
            }
        }

        override public function toXML():XML
        {
            var xml:XML = new XML("<" + type + "/>");
            xml.@id = this.id;
            xml.@index = this.index;
            xml.@name = this.name;
            var zonesXML:XML = <zones/>;
            var zones:Array = _zones.slice();
            if (_globalZone != null)
            {
                zones.unshift(_globalZone);
            }
            for each (var zone:Zone in zones)
            {
                zonesXML.appendChild(zone.toXML());
            }
            xml.appendChild(zonesXML);
            return xml;
        }

        /**
         * A helper method for creating a zone. Subclasses can override this method to define how zones should be built.
         * It uses the _zoneClass property to know what class to instantiate when creating a zone.
         */
        protected function buildZone(generator:GeneratorRecord, records:Array):Zone
        {
            var zone:Zone = new _zoneClass();
            for each (var operator:Operator in generator.operators)
            {
                if (operator is RangeOperator)
                {
                    zone[operator.name] = RangeOperator(operator).values;
                }
                else if (!operator.isUnusedType)
                {
                    zone[operator.name] = operator.amount;
                }
            }
            return zone;
        }
    }
}
