package zero.ext.flx;

import flixel.FlxObject;
import flixel.math.FlxPoint;

class FlxObjectExt
{

    inline public static function get_anchor(object:FlxObject):FlxPoint
	{
		return FlxPoint.get(object.x + object.width * 0.5, object.y + object.height);
	}

    inline public static function set_position(object:FlxObject, point:FlxPoint)
    {
        object.setPosition(point.x, point.y);
    }

    inline public static function set_anchor_position(object:FlxObject, point:FlxPoint)
    {
        object.setPosition(point.x - object.width * 0.5, point.y - object.height);
    }

    inline public static function set_midpoint_position(object:FlxObject, point:FlxPoint)
    {
        object.setPosition(point.x - object.width * 0.5, point.y - object.height * 0.5);
    }

}