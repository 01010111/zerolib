package zero.utilities;

using Math;
using zero.extensions.FloatExt;

/**
 * A simple Vector class
 * 
 * **Usage:**
 * 
 * - Initialize using Vec2.get() `var vec = Vec2.get(0, 0);`
 * - Recycle vectors when you're done with them: `my_vector.put()`
 */
 abstract Vec2(Array<Float>) {

	static var pool:Array<Vec2> = [];

	public static var UP = Vec2.get(0, -1);
	public static var DOWN = Vec2.get(0, 1);
	public static var LEFT = Vec2.get(-1, 0);
	public static var RIGHT = Vec2.get(1, 0);
	public static var use_radians:Bool = false;

	public static function get(x:Float = 0, y:Float = 0):Vec2 {
		if (pool.length > 0) return pool.shift().set(x, y);
		return new Vec2(x, y);
	}

	static function zero(v:Float) return Math.abs(v) <= 1e-8 ? 0 : v;
	
	public var radians(get, set):Float;
	public var length(get, set):Float;

	public var x(get, set):Float;
	public var y(get, set):Float;
	public var angle(get, set):Float;
	public var degrees(get, set):Float;

	public function new(x:Float, y:Float) {
		this = [Math.atan2(y, x), Math.sqrt(x * x + y * y)];
	}
	
	public function set(x:Float = 0, y:Float = 0):Vec2 {
		length = Math.sqrt(x * x + y * y);
		radians = Math.atan2(y, x);
		return cast this;
	}

	public function put() {
		this[0] = null;
		this[1] = null;
		pool.push(cast this);
	}

	public inline function normalize() return set(x / length, y / length);
	public inline function scale(scalar:Float) return set(x * scalar, y * scalar);
	public inline function dot(v:Vec2):Float return zero(x * v.x + y * v.y);
	public inline function cross(v:Vec2):Float return zero(x * v.y - y * v.x);
	public inline function distance(v:Vec2):Float return Math.sqrt(Math.pow(x - v.x, 2) + Math.pow(y - v.y, 2));
	public inline function rad_between(v:Vec2):Float return Math.atan2(v.y - y, v.x - x);
	public inline function deg_between(v:Vec2):Float return Math.atan2(v.y - y, v.x - x) * (180 / Math.PI);
	public inline function angle_between(v:Vec2):Float return use_radians ? rad_between(v) : deg_between(v);
	public inline function in_circle(cx:Float, cy:Float, cr:Float) return Math.sqrt(Math.pow(x - cx, 2) + Math.pow(y - cy, 2)) <= cr;

	public inline function copy_from(v:Vec2) return set(v.x, v.y);
	public inline function copy():Vec2 return Vec2.get(x, y);
	public inline function toString() return 'x:$x, y:$y, length:$length, angle:$angle';

	function get_radians() return this[0];
	function get_length() return Math.abs(this[1]);
	function get_x() return zero(length * Math.cos(radians));
	function get_y() return zero(length * Math.sin(radians));
	function get_angle() return use_radians ? radians : degrees;
	function get_degrees() return radians * (180 / Math.PI);

	function set_radians(v) return this[0] = v;
	function set_length(v) {
		if (v < 0.0) radians += Math.PI;
		return this[1] = Math.abs(v);
	}
	
	function set_x(v:Float) {
		if (this[2] == v) return v;
		this[2] = v;
		var y = get_y();
		length = Math.sqrt(v * v + y * y);
		radians = Math.atan2(y, v);
		return v;
	}
	
	function set_y(v:Float) {
		if (this[3] == v) return v;
		this[3] = v;
		var x = get_x();
		length = Math.sqrt(x * x + v * v);
		radians = Math.atan2(v, x);
		return v;
	}

	function set_degrees(v:Float) {
		radians = v * (Math.PI / 180);
		return v;
	}
	
	function set_angle(v:Float) {
		radians = use_radians ? v : v * (Math.PI / 180);
		return v;
	}

	@:op(A + B) static function add(v1:Vec2, v2:Vec2) return Vec2.get(v1.x + v2.x, v1.y + v2.y);
	@:op(A - B) static function subtract(v1:Vec2, v2:Vec2) return Vec2.get(v1.x - v2.x, v1.y - v2.y);
	@:op(A * B) static function dot_product(v1:Vec2, v2:Vec2) return v1.dot(v2);
	@:op(A / B) static function cross_product(v1:Vec2, v2:Vec2) return v1.cross(v2);
	@:op(A == B) static function is_equal(v1:Vec2, v2:Vec2) return v1.radians == v2.radians && v1.length == v2.length; 
	
	@:op(A + B) static function add_float(v1:Vec2, f:Float) return Vec2.get(v1.x + f, v1.y + f);
	@:op(A - B) static function subtract_float(v1:Vec2, f:Float) return Vec2.get(v1.x - f, v1.y - f);
	@:op(A * B) static function multiply_float(v1:Vec2, f:Float) return Vec2.get(v1.x * f, v1.y * f);
	@:op(A / B) static function divide_float(v1:Vec2, f:Float) return Vec2.get(v1.x / f, v1.y / f);
}