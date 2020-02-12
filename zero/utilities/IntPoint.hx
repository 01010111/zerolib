package zero.utilities;

using Math;

/**
 * A basic point consisting of two Integers - X and Y
 * 
 * **Usage:**
 * 
 * - Initialize using IntPoint.get() `var point = IntPoint.get(0, 0);`
 * - Or with an array `var point:IntPoint = [0, 1];`
 * - Recycle points when you're done with them: `my_point.put()`
 */
abstract IntPoint(Array<Int>)
{
	
	// Array creation/access
	@:from static function from_array_int(input:Array<Int>) return IntPoint.get(input[0], input[1]);
	@:arrayAccess function arr_set(n:Int, v:Int) n < 0 || n > 1 ? return : this[n] = v;
	@:arrayAccess function arr_get(n:Int):Int return this[n.min(1).max(0).floor()];

	// Pooling
	static var pool:Array<IntPoint> = [];
	public static function get(x:Int = 0, y:Int = 0):IntPoint return pool != null && pool.length > 0 ? pool.shift().set(x, y) : new IntPoint(x, y);
	public inline function put()
	{
		pool.push(cast this);
		this = null;
	}

	inline function new(x:Int = 0, y:Int = 0) this = [x, y];
	public inline function set(x:Int = 0, y:Int = 0) {
		this[0] = x;
		this[1] = y;
		return cast this;
	}

	public var x(get, set):Int;
	inline function get_x() return this[0];
	inline function set_x(v) return this[0] = v;

	public var y(get, set):Int;
	inline function get_y() return this[1];
	inline function set_y(v) return this[1] = v;

	public var length(get, never):Float;
	inline function get_length() return (x*x + y*y).sqrt();

	public var angle(get, never):Float;
	inline function get_angle() return ((Math.atan2(y, x) * (180 / Math.PI)) % 360 + 360) % 360;

	public inline function copy_from(p:IntPoint):IntPoint return set(p.x, p.y);
	public inline function copy():IntPoint return IntPoint.get(x, y);
	public inline function equals(p:IntPoint):Bool return x == p.x && y == p.y;
	public inline function distance(p:IntPoint):Float return (p - this).length;
	public inline function toString():String return 'x: $x | y: $y';

	// Operator Overloads
	@:op(A + B) static function add(v1:IntPoint, v2:IntPoint):IntPoint return IntPoint.get(v1.x + v2.x, v1.y + v2.y);
	@:op(A + B) static function add_int(v:IntPoint, n:Int):IntPoint return IntPoint.get(v.x + n, v.y + n);
	@:op(A - B) static function subtract(v1:IntPoint, v2:IntPoint):IntPoint return IntPoint.get(v1.x - v2.x, v1.y - v2.y);
	@:op(A - B) static function subtract_int(v:IntPoint, n:Int):IntPoint return IntPoint.get(v.x - n, v.y - n);
	@:op(A * B) static function multiply(v1:IntPoint, v2:IntPoint):IntPoint return IntPoint.get(v1.x * v2.x, v1.y * v2.y);
	@:op(A * B) static function multiply_int(v:IntPoint, n:Int):IntPoint return IntPoint.get(v.x * n, v.y * n);
	@:op(A % B) static function mod(v1:IntPoint, v2:IntPoint):IntPoint return IntPoint.get(v1.x % v2.x, v1.y % v2.y);
	@:op(A % B) static function mod_int(v:IntPoint, n:Int):IntPoint return IntPoint.get(v.x % n, v.y % n);

}