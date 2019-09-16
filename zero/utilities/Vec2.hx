package zero.utilities;

using Math;

/**
 * A simple Vector class
 */
abstract Vec2(Array<Float>)
{

	public static var UP (default, never):Vec2 = [0, -1];
	public static var DOWN (default, never):Vec2 = [0, 1];
	public static var LEFT (default, never):Vec2 = [-1, 0];
	public static var RIGHT (default, never):Vec2 = [1, 0];

	// Utility
	static var epsilon:Float = 1e-8;
	static function zero(n:Float):Float return n.abs() <= epsilon ? 0 : n;
	
	// Array creation/access
	@:from static function from_array_float(input:Array<Float>) return new Vec2(input[0], input[1]);
	@:from static function from_array_int(input:Array<Int>) return new Vec2(input[0], input[1]);
	@:arrayAccess function arr_set(n:Int, v:Float) n < 0 || n > 1 ? return : this[n] = v;
	@:arrayAccess function arr_get(n:Int):Float return this[n.min(1).max(0).floor()];

	// Pooling
	static var pool:Array<Vec2> = [];
	public static function get(x:Float = 0, y:Float = 0):Vec2 return pool.length > 0 ? pool.shift().set(x, y) : new Vec2(x, y);
	public inline function put()
	{
		pool.push(this);
		this = null;
	}

	function new(x:Float = 0, y:Float = 0) this = [x, y];
	public inline function set(x:Float = 0, y:Float = 0):Vec2
	{
		this[0] = zero(x);
		this[1] = zero(y);
		return this;
	}

	public var x (get, set):Float;
	function get_x() return this[0];
	function set_x(v) return this[0] = v;

	public var y (get, set):Float;
	function get_y() return this[1];
	function set_y(v) return this[1] = v;

	public var length (get, set):Float;
	inline function get_length() return (x*x + y*y).sqrt();
	inline function set_length(v:Float)
	{
		normalize();
		scale(v);
		return v;
	}

	public var angle (get, set):Float;
	function get_angle() return ((Math.atan2(y, x) * (180 / Math.PI)) % 360 + 360) % 360;
	function set_angle(v:Float)
	{
		v *= (Math.PI / 180);
		set(length * v.cos(), length * v.sin());
		return v;
	}

	// These functions modify the vector in place!
	public inline function copy_from(v:Vec2):Vec2 return set(v.x, v.y);
	public inline function normalize():Vec2 return set(x / length, y / length);
	public inline function scale(n:Float):Vec2 return set(x * n, y * n);

	public inline function copy():Vec2 return Vec2.get(x, y);
	public inline function equals(v:Vec2):Bool return x == v.x && y == v.y;
	public inline function dot(v:Vec2):Float return zero(x * v.x + y * v.y);
	public inline function cross(v:Vec2):Float return zero(x * v.y - y * v.x);
	public inline function facing(v:Vec2):Float return zero(x / length * v.x / v.length + y / length * v.y / v.length);
	public inline function distance(v:Vec2):Float return (v - this).length;
	public inline function toString():String return 'x: $x | y: $y | length: $length | angle: $angle';

	// Operator Overloads
	@:op(A + B) static function add(v1:Vec2, v2:Vec2):Vec2 return Vec2.get(v1.x + v2.x, v1.y + v2.y);
	@:op(A + B) static function add_f(v:Vec2, n:Float):Vec2 return Vec2.get(v.x + n, v.y + n);
	@:op(A - B) static function subtract(v1:Vec2, v2:Vec2):Vec2 return Vec2.get(v1.x - v2.x, v1.y - v2.y);
	@:op(A - B) static function subtract_f(v:Vec2, n:Float):Vec2 return Vec2.get(v.x - n, v.y - n);
	@:op(A * B) static function multiply(v1:Vec2, v2:Vec2):Vec2 return Vec2.get(v1.x * v2.x, v1.y * v2.y);
	@:op(A * B) static function multiply_f(v:Vec2, n:Float):Vec2 return Vec2.get(v.x * n, v.y * n);
	@:op(A / B) static function divide(v1:Vec2, v2:Vec2):Vec2 return Vec2.get(v1.x / v2.x, v1.y / v2.y);
	@:op(A / B) static function divide_f(v:Vec2, n:Float):Vec2 return Vec2.get(v.x / n, v.y / n);
	@:op(A % B) static function mod(v1:Vec2, v2:Vec2):Vec2 return Vec2.get(v1.x % v2.x, v1.y % v2.y);
	@:op(A % B) static function mod_f(v:Vec2, n:Float):Vec2 return Vec2.get(v.x % n, v.y % n);

	// Swizzling
	@:dox(hide) public var xx (get, never):Vec2; private function get_xx() return Vec2.get(x, x);
	@:dox(hide) public var xy (get, never):Vec2; private function get_xy() return Vec2.get(x, y);
	@:dox(hide) public var yx (get, never):Vec2; private function get_yx() return Vec2.get(y, x);
	@:dox(hide) public var yy (get, never):Vec2; private function get_yy() return Vec2.get(y, y);

	@:dox(hide) public var xxxx (get, never):Vec4; private function get_xxxx() return Vec4.get(x, x, x, x);
	@:dox(hide) public var xxxy (get, never):Vec4; private function get_xxxy() return Vec4.get(x, x, x, y);
	@:dox(hide) public var xxyx (get, never):Vec4; private function get_xxyx() return Vec4.get(x, x, y, x);
	@:dox(hide) public var xxyy (get, never):Vec4; private function get_xxyy() return Vec4.get(x, x, y, y);
	@:dox(hide) public var xyxx (get, never):Vec4; private function get_xyxx() return Vec4.get(x, y, x, x);
	@:dox(hide) public var xyxy (get, never):Vec4; private function get_xyxy() return Vec4.get(x, y, x, y);
	@:dox(hide) public var xyyx (get, never):Vec4; private function get_xyyx() return Vec4.get(x, y, y, x);
	@:dox(hide) public var xyyy (get, never):Vec4; private function get_xyyy() return Vec4.get(x, y, y, y);
	@:dox(hide) public var yxxx (get, never):Vec4; private function get_yxxx() return Vec4.get(y, x, x, x);
	@:dox(hide) public var yxxy (get, never):Vec4; private function get_yxxy() return Vec4.get(y, x, x, y);
	@:dox(hide) public var yxyx (get, never):Vec4; private function get_yxyx() return Vec4.get(y, x, y, x);
	@:dox(hide) public var yxyy (get, never):Vec4; private function get_yxyy() return Vec4.get(y, x, y, y);
	@:dox(hide) public var yyxx (get, never):Vec4; private function get_yyxx() return Vec4.get(y, y, x, x);
	@:dox(hide) public var yyxy (get, never):Vec4; private function get_yyxy() return Vec4.get(y, y, x, y);
	@:dox(hide) public var yyyx (get, never):Vec4; private function get_yyyx() return Vec4.get(y, y, y, x);
	@:dox(hide) public var yyyy (get, never):Vec4; private function get_yyyy() return Vec4.get(y, y, y, y);

}