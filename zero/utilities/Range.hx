package zero.utilities;

using Math;
using zero.extensions.FloatExt;

/**
 * A class representing a range of floating point numbers
 * 
 * **Usage:**
 * 
 * - Initialize using Range.get() `var range = Range.get(0, 0);`
 * - Or with an array `var range:Range = [0, 1];`
 * - Recycle ranges when you're done with them: `my_range.put()`
 */
abstract Range(Vec2)
{
	
	// Array creation/access
	@:from static function from_array_float(input:Array<Float>) return new Range(input[0], input[1]);
	@:from static function from_array_int(input:Array<Int>) return new Range(input[0], input[1]);

	// Pooling
	static var pool:Array<Range> = [];
	public static function get(min:Float = 0, max:Float = 1):Range return pool.length > 0 ? pool.shift().set(min, max) : new Range(min, max);
	public inline function put()
	{
		pool.push(cast this);
		this = null;
	}

	function new(min:Float = 0, max:Float = 1) this = Vec2.get(min, max);
	public inline function set(min:Float = 0, max:Float = 1):Range
	{
		this.x = min;
		this.y = max;
		return cast this;
	}

	public var min (get, set):Float;
	function get_min() return this.x;
	function set_min(v) {
		this.x = v;
		return v;
	}

	public var max (get, set):Float;
	function get_max() return this.y;
	function set_max(v) {
		this.y = v;
		return v;
	}

	public var difference (get, never):Float;
	inline function get_difference() return max - min;

	public inline function in_range(v:Float):Bool return v >= min && v <= max;
	public inline function copy_from(v:Range):Range return set(v.min, v.max);
	public inline function copy():Range return Range.get(min, max);
	public inline function equals(v:Range):Bool return min == v.min && max == v.max;
	public inline function toString():String return 'min: $min | max: $max | difference: $difference';
	public inline function get_random():Float return max.get_random(min);
	public inline function normalize(v:Float):Float return v.map(min, max, 0, 1);
	public inline function denormalize(v:Float):Float return v.map(0, 1, min, max);

	// Operator Overloads
	@:op(A + B) static function add(v:Range, n:Float):Range return Range.get(v.min + n, v.max + n);
	@:op(A - B) static function subtract(v:Range, n:Float):Range return Range.get(v.min - n, v.max - n);
	@:op(A * B) static function multiply(v:Range, n:Float):Range return Range.get(v.min * n, v.max * n);
	@:op(A / B) static function divide(v:Range, n:Float):Range return Range.get(v.min / n, v.max / n);
	@:op(A % B) static function mod(v:Range, n:Float):Range return Range.get(v.min % n, v.max % n);

}