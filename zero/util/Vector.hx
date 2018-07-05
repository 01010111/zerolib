package zero.util;

import flixel.math.FlxPoint;

using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

/**
 *  @author 01010111
 *  A 2D Vector
 */
class Vector
{
	
	@:isVar public var x (default, set) : Float = 0;
	function set_x(x:Float):Float { return this.x = x; }
	@:isVar public var y (default, set) : Float = 0;
	function set_y(y:Float):Float { return this.y = y; }

	@:isVar public var len (get, set) : Float = 0;
	function get_len() { return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));  }
	function set_len(value:Float):Float
	{
		set_xy(Math.cos(angle.deg_to_rad()) * value, Math.sin(angle.deg_to_rad()) * value);
		return value;
	}
	@:isVar public var angle (get, set) : Float = 0;
	function get_angle() { return Math.atan2(y, x).rad_to_deg(); }
	function set_angle(value:Float):Float
	{
		set_xy(Math.cos(value.deg_to_rad()) * len, Math.sin(value.deg_to_rad()) * len);
		return value;
	}

	public function new(x: Float = 0, y:Float = 0) set_xyz(x, y);
	public inline function copy_from(v:Vector):Vector return new Vector(v.x, v.y);
	public inline function to_flx():FlxPoint return FlxPoint.get(x, y);
	public inline function from_flx(p:FlxPoint) set_xy(p.x, p.y);
	public inline function get_inverse():Vector return new Vector(-x, -y);

	public function set_xy(x:Float = 0, ?y:Float)
	{
		if (y == null) y = x;
		this.x = x;
		this.y = y;
	}

}