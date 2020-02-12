package zero.utilities;

using Math;

/**
 * A simple Rectangle class
 * 
 * **Usage:**
 * 
 * - Initialize using Rect.get() `var rect = Rect.get(0, 0, 100, 100);`
 * - Or with an array `var rect:Rect = [0, 0, 100, 100];`
 * - Recycle rectangles when you're done with them: `my_rect.put()`
 */
@:forward
abstract Rect(Vec4)
{

	static var epsilon:Float = 1e-8;
	static function zero(n:Float):Float return n.abs() <= epsilon ? 0 : n;

	static var pool:Array<Rect> = [];
	public static function get(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Rect return pool != null && pool.length > 0 ? pool.shift().set(x, y, width, height) : new Rect(x, y, width, height);
	public inline function put()
	{
		pool.push(cast this);
		this = null;
	}

	@:from static function from_array_float(input:Array<Float>) return Rect.get(input[0], input[1], input[2], input[3]);
	@:from static function from_array_int(input:Array<Int>) return Rect.get(input[0], input[1], input[2], input[3]);
	@:arrayAccess function arr_set(n:Int, v:Float) n < 0 || n > 3 ? return : this[n] = v;
	@:arrayAccess function arr_get(n:Int):Float return this[n.min(3).max(0).floor()];

	public var width (get, set):Float;
	function get_width() return this.z;
	function set_width(v) return this.z = v;

	public var height (get, set):Float;
	function get_height() return this.w;
	function set_height(v) return this.w = v;

	public var top (get, set):Float;
	function get_top() return this.y;
	function set_top(v) return this.y = v;

	public var left (get, set):Float;
	function get_left() return this.x;
	function set_left(v) return this.x = v;

	public var bottom (get, set):Float;
	function get_bottom() return this.y + height;
	function set_bottom(v:Float)
	{
		height = v - this.y;
		return v;
	}

	public var right (get, set):Float;
	function get_right() return this.x + width;
	function set_right(v:Float)
	{
		width = v - this.x;
		return v;
	}

	public var midpoint (get, never):Vec2;
	function get_midpoint() return Vec2.get(this.x + width/2, this.y + height/2);

	function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) this = [x, y, z, w];
	public inline function set(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0):Rect
	{
		this[0] = zero(x);
		this[1] = zero(y);
		this[2] = zero(z);
		this[3] = zero(w);
		return cast this;
	}

	public function toString():String return 'x: ${this.x} | y: ${this.y} | width: $width | height: $height';

	public inline function area():Float return width * height;
	public inline function contains_point(vec2:Vec2) return top <= vec2.y && bottom >= vec2.y && left <= vec2.x && right >= vec2.x;
	public inline function is_empty():Bool return width == 0 || height == 0;
	public inline function set_position(v:Vec2):Rect return set(v.x, v.y, width, height);
	public inline function equals(v:Rect):Bool return this.x == v.x && this.y == v.y && width == v.width && height == v.height;
	public inline function intersection(v:Rect):Rect
	{
		var x0 = left.max(v.left);
		var x1 = right.min(v.right);
		if (x1 < x0) return get();
		var y0 = top.max(v.top);
		var y1 = bottom.min(v.bottom);
		if (y1 < y0) return get();
		return get(x0, y0, x1 - x0, y1 - y0);
	}

	@:op(A + B) static function add(v1:Rect, v2:Rect):Rect return Rect.get(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
	@:op(A + B) static function add_f(v:Rect, n:Float):Rect return Rect.get(v.x + n, v.y + n, v.z + n, v.w + n);
	@:op(A + B) static function add_p(v:Rect, v2:Vec2):Rect return Rect.get(v.x + v2.x, v.y + v2.y, v.z, v.w);
	@:op(A - B) static function subtract(v1:Rect, v2:Rect):Rect return Rect.get(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
	@:op(A - B) static function subtract_f(v:Rect, n:Float):Rect return Rect.get(v.x - n, v.y - n, v.z - n, v.w - n);
	@:op(A + B) static function subtract_p(v:Rect, v2:Vec2):Rect return Rect.get(v.x - v2.x, v.y - v2.y, v.z, v.w);
	@:op(A * B) static function multiply(v1:Rect, v2:Rect):Rect return Rect.get(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z, v1.w * v2.w);
	@:op(A * B) static function multiply_f(v:Rect, n:Float):Rect return Rect.get(v.x * n, v.y * n, v.z * n, v.w * n);
	@:op(A + B) static function multiply_p(v:Rect, v2:Vec2):Rect return Rect.get(v.x * v2.x, v.y * v2.y, v.z, v.w);
	@:op(A / B) static function divide(v1:Rect, v2:Rect):Rect return Rect.get(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z, v1.w / v2.w);
	@:op(A / B) static function divide_f(v:Rect, n:Float):Rect return Rect.get(v.x / n, v.y / n, v.z / n, v.w / n);
	@:op(A + B) static function divide_p(v:Rect, v2:Vec2):Rect return Rect.get(v.x / v2.x, v.y / v2.y, v.z, v.w);
	@:op(A % B) static function mod(v1:Rect, v2:Rect):Rect return Rect.get(v1.x % v2.x, v1.y % v2.y, v1.z % v2.z, v1.w % v2.w);
	@:op(A % B) static function mod_f(v:Rect, n:Float):Rect return Rect.get(v.x % n, v.y % n, v.z % n, v.w % n);
	@:op(A + B) static function mod_p(v:Rect, v2:Vec2):Rect return Rect.get(v.x % v2.x, v.y % v2.y, v.z, v.w);

}