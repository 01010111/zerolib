package zero.util;

import flixel.math.FlxPoint;

using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

/**
 *  Just a typical 2D Vector class
 */
class Vector
{
	
	/**
	 *  vector x value
	 */
	@:isVar public var x (default, set) : Float = 0;
	function set_x(x:Float):Float { return this.x = x; }
	
	/**
	 *  vector y value
	 */
	@:isVar public var y (default, set) : Float = 0;
	function set_y(y:Float):Float { return this.y = y; }

	/**
	 *  vector length
	 */
	@:isVar public var len (get, set) : Float = 0;
	function get_len() { return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));  }
	function set_len(value:Float):Float
	{
		set_xy(Math.cos(angle.deg_to_rad()) * value, Math.sin(angle.deg_to_rad()) * value);
		return value;
	}

	/**
	 *  vector angle
	 */
	@:isVar public var angle (get, set) : Float = 0;
	function get_angle() { return Math.atan2(y, x).rad_to_deg(); }
	function set_angle(value:Float):Float
	{
		set_xy(Math.cos(value.deg_to_rad()) * len, Math.sin(value.deg_to_rad()) * len);
		return value;
	}

	/**
	 *  Create a new 2D vector with x and y coordinates
	 *  @param x	x coordinate
	 *  @param y	y coordinate
	 */
	public function new(x: Float = 0, y:Float = 0) set_xy(x, y);

	/**
	 *  returns a copy of an input vector
	 *  @param v	input vector
	 *  @return		Vector
	 */
	public inline function copy_from(v:Vector):Vector return new Vector(v.x, v.y);
	
	/**
	 *  converts Vector to FlxPoint
	 *  @return	FlxPoint
	 */
	public inline function to_flx():FlxPoint return FlxPoint.get(x, y);
	
	/**
	 *  copies FlxPoint values to Vector
	 *  @param p	input FlxPoint
	 */
	public inline function from_flx(p:FlxPoint) set_xy(p.x, p.y);
	
	/**
	 *  returns an inverted copy of a vector
	 *  @return Vector
	 */
	public inline function get_inverse():Vector return new Vector(-x, -y);

	/**
	 *  Set x and y values of Vector
	 *  @param x	x coordinate
	 *  @param y	y coordinate
	 */
	public function set_xy(x:Float = 0, ?y:Float)
	{
		if (y == null) y = x;
		this.x = x;
		this.y = y;
	}

}