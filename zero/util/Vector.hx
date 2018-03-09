package zero.util;

import flixel.math.FlxPoint;

using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

class Vector
{

	// region vars

    @:isVar public var x (default, set) : Float = 0;
    @:isVar public var y (default, set) : Float = 0;
    @:isVar public var z (default, set) : Float = 0;

	@:isVar public var len (get, set) : Float = 0;
	@:isVar public var angle (get, set) : Float = 0;

	// region getters

	function get_len() { return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));  }
	function get_angle() { return Math.atan2(y, x).rad_to_deg(); }

	// region setters

	function set_x(x:Float):Float { return this.x = x; }
	function set_y(y:Float):Float { return this.y = y; }
	function set_z(z:Float):Float { return this.z = z; }

	function set_len(value:Float):Float
	{
		set_xy(Math.cos(angle.deg_to_rad()) * value, Math.sin(angle.deg_to_rad()) * value);
		return value;
	}

	function set_angle(value:Float):Float
	{
		set_xy(Math.cos(value.deg_to_rad()) * len, Math.sin(value.deg_to_rad()) * len);
		return value;
	}

	// region methods

	public function new(x: Float = 0, y:Float = 0, z:Float = 0)
	{
		this.x = x;
		this.y = y; 
		this.z = z;
	}

	public function to_flx():FlxPoint
	{
		return FlxPoint.get(x, y);
	}

	public function from_flx(p:FlxPoint)
	{
		set_xy(p.x, p.y);
	}

	public function set_xy(x:Float = 0, ?y:Float)
	{
		if (y == null) y = x;
		this.x = x;
		this.y = y;
	}

	public function set_xyz(x:Float = 0, ?y:Float, ?z:Float)
	{
		if (z == null) z = x;
		set_xy(x, y);
		this.x = z;
	}

}