package zero.ext.flx;

import flixel.FlxObject;
import flixel.math.FlxPoint;

/**
 *  @author 01010111 
 */
class FlxObjectExt
{

    /**
     *  Returns a bottom center point of a FlxObject
     *  @param object - 
     *  @return FlxPoint
     */
    public static inline function get_anchor(object:FlxObject):FlxPoint return FlxPoint.get(object.x + object.width * 0.5, object.y + object.height);

    /**
     *  Sets the position of a FlxObject using a FlxPoint
     *  @param object - 
     *  @param point - 
     */
    public static inline function set_position(object:FlxObject, point:FlxPoint) object.setPosition(point.x, point.y);

    /**
     *  Sets the anchor (bottom center) position of a FlxObject using a FlxPoint
     *  @param object - 
     *  @param point - 
     */
    public static inline function set_anchor_position(object:FlxObject, point:FlxPoint) object.setPosition(point.x - object.width * 0.5, point.y - object.height);

    /**
     *  Sets the midpoint position of a FlxObject using a FlxPoint
     *  @param object - 
     *  @param point - 
     */
    public static inline function set_midpoint_position(object:FlxObject, point:FlxPoint) object.setPosition(point.x - object.width * 0.5, point.y - object.height * 0.5);

}