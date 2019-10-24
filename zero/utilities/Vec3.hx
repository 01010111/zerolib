package zero.utilities;

using Math;

/**
 * A simple Vector class
 * 
 * **Usage:**
 * 
 * - Initialize using Vec3.get() `var vec = Vec3.get(0, 1, 2);`
 * - Or with an array `var vec:Vec3 = [0, 1, 2];`
 * - Recycle vectors when you're done with them: `my_vector.put()`
 */
abstract Vec3(Array<Float>)
{

	// Utility
	static var epsilon:Float = 1e-8;
	static function zero(n:Float):Float return n.abs() <= epsilon ? 0 : n;
	
	// Array creation/access
	@:from static function from_array_float(input:Array<Float>) return new Vec3(input[0], input[1], input[2]);
	@:from static function from_array_int(input:Array<Int>) return new Vec3(input[0], input[1], input[2]);
	@:arrayAccess function arr_set(n:Int, v:Float) n < 0 || n > 2 ? return : this[n] = v;
	@:arrayAccess function arr_get(n:Int):Float return this[n.min(2).max(0).floor()];

	// Pooling
	static var pool:Array<Vec3> = [];
	public static function get(x:Float = 0, y:Float = 0, z:Float = 0):Vec3 return pool.length > 0 ? pool.shift().set(x, y, z) : new Vec3(x, y, z);
	public inline function put()
	{
		pool.push(this);
		this = null;
	}

	function new(x:Float = 0, y:Float = 0, z:Float = 0) this = [x, y, z];
	public inline function set(x:Float = 0, y:Float = 0, z:Float = 0):Vec3
	{
		this[0] = zero(x);
		this[1] = zero(y);
		this[2] = zero(z);
		return this;
	}

	public var x (get, set):Float;
	function get_x() return this[0];
	function set_x(v) return this[0] = v;

	public var y (get, set):Float;
	function get_y() return this[1];
	function set_y(v) return this[1] = v;

	public var z (get, set):Float;
	function get_z() return this[2];
	function set_z(v) return this[2] = v;

	// These functions modify the vector in place!
	public inline function copy_from(v:Vec3):Vec3 return set(v.x, v.y, v.z);
	public inline function scale(n:Float):Vec3 return set(x * n, y * n, z * n);

	public inline function copy():Vec3 return Vec3.get(x, y, z);
	public inline function equals(v:Vec3):Bool return x == v.x && y == v.y && z == v.z;
	public inline function to_hex():Int return ((x * 255).round() & 0xFF) << 16 | ((y * 255).round() & 0xFF) << 8 | ((z * 255).round() & 0xFF);
	public inline function toString():String return 'x: $x | y: $y | z: $z';

	/*
	TODO :
	dot
	cross
	distance
	length
	rotate
	*/

	// Operator Overloads
	@:op(A + B) static function add(v1:Vec3, v2:Vec3):Vec3 return Vec3.get(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
	@:op(A + B) static function add_f(v:Vec3, n:Float):Vec3 return Vec3.get(v.x + n, v.y + n, v.z + n);
	@:op(A - B) static function subtract(v1:Vec3, v2:Vec3):Vec3 return Vec3.get(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
	@:op(A - B) static function subtract_f(v:Vec3, n:Float):Vec3 return Vec3.get(v.x - n, v.y - n, v.z - n);
	@:op(A * B) static function multiply(v1:Vec3, v2:Vec3):Vec3 return Vec3.get(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
	@:op(A * B) static function multiply_f(v:Vec3, n:Float):Vec3 return Vec3.get(v.x * n, v.y * n, v.z * n);
	@:op(A / B) static function divide(v1:Vec3, v2:Vec3):Vec3 return Vec3.get(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z);
	@:op(A / B) static function divide_f(v:Vec3, n:Float):Vec3 return Vec3.get(v.x / n, v.y / n, v.z / n);
	@:op(A % B) static function mod(v1:Vec3, v2:Vec3):Vec3 return Vec3.get(v1.x % v2.x, v1.y % v2.y, v1.z % v2.z);
	@:op(A % B) static function mod_f(v:Vec3, n:Float):Vec3 return Vec3.get(v.x % n, v.y % n, v.z % n);

	// Swizzling
	@:dox(hide) public var xx (get, never):Vec2; private function get_xx() return Vec2.get(x, x);
	@:dox(hide) public var xy (get, never):Vec2; private function get_xy() return Vec2.get(x, y);
	@:dox(hide) public var xz (get, never):Vec2; private function get_xz() return Vec2.get(x, z);
	@:dox(hide) public var yx (get, never):Vec2; private function get_yx() return Vec2.get(y, x);
	@:dox(hide) public var yy (get, never):Vec2; private function get_yy() return Vec2.get(y, y);
	@:dox(hide) public var yz (get, never):Vec2; private function get_yz() return Vec2.get(y, z);
	@:dox(hide) public var zx (get, never):Vec2; private function get_zx() return Vec2.get(z, x);
	@:dox(hide) public var zy (get, never):Vec2; private function get_zy() return Vec2.get(z, y);
	@:dox(hide) public var zz (get, never):Vec2; private function get_zz() return Vec2.get(z, z);
	@:dox(hide) public var xxx (get, never):Vec3; private function get_xxx() return Vec3.get(x, x, x);
	@:dox(hide) public var xxy (get, never):Vec3; private function get_xxy() return Vec3.get(x, x, y);
	@:dox(hide) public var xxz (get, never):Vec3; private function get_xxz() return Vec3.get(x, x, z);
	@:dox(hide) public var xyx (get, never):Vec3; private function get_xyx() return Vec3.get(x, y, x);
	@:dox(hide) public var xyy (get, never):Vec3; private function get_xyy() return Vec3.get(x, y, y);
	@:dox(hide) public var xyz (get, never):Vec3; private function get_xyz() return Vec3.get(x, y, z);
	@:dox(hide) public var xzx (get, never):Vec3; private function get_xzx() return Vec3.get(x, z, x);
	@:dox(hide) public var xzy (get, never):Vec3; private function get_xzy() return Vec3.get(x, z, y);
	@:dox(hide) public var xzz (get, never):Vec3; private function get_xzz() return Vec3.get(x, z, z);
	@:dox(hide) public var yxx (get, never):Vec3; private function get_yxx() return Vec3.get(x, x, x);
	@:dox(hide) public var yxy (get, never):Vec3; private function get_yxy() return Vec3.get(x, x, y);
	@:dox(hide) public var yxz (get, never):Vec3; private function get_yxz() return Vec3.get(x, x, z);
	@:dox(hide) public var yyx (get, never):Vec3; private function get_yyx() return Vec3.get(x, y, x);
	@:dox(hide) public var yyy (get, never):Vec3; private function get_yyy() return Vec3.get(x, y, y);
	@:dox(hide) public var yyz (get, never):Vec3; private function get_yyz() return Vec3.get(x, y, z);
	@:dox(hide) public var yzx (get, never):Vec3; private function get_yzx() return Vec3.get(x, z, x);
	@:dox(hide) public var yzy (get, never):Vec3; private function get_yzy() return Vec3.get(x, z, y);
	@:dox(hide) public var yzz (get, never):Vec3; private function get_yzz() return Vec3.get(x, z, z);
	@:dox(hide) public var zxx (get, never):Vec3; private function get_zxx() return Vec3.get(x, x, x);
	@:dox(hide) public var zxy (get, never):Vec3; private function get_zxy() return Vec3.get(x, x, y);
	@:dox(hide) public var zxz (get, never):Vec3; private function get_zxz() return Vec3.get(x, x, z);
	@:dox(hide) public var zyx (get, never):Vec3; private function get_zyx() return Vec3.get(x, y, x);
	@:dox(hide) public var zyy (get, never):Vec3; private function get_zyy() return Vec3.get(x, y, y);
	@:dox(hide) public var zyz (get, never):Vec3; private function get_zyz() return Vec3.get(x, y, z);
	@:dox(hide) public var zzx (get, never):Vec3; private function get_zzx() return Vec3.get(x, z, x);
	@:dox(hide) public var zzy (get, never):Vec3; private function get_zzy() return Vec3.get(x, z, y);
	@:dox(hide) public var zzz (get, never):Vec3; private function get_zzz() return Vec3.get(x, z, z);
	@:dox(hide) public var xxxx (get, never):Vec4; private function get_xxxx() return Vec4.get(x, x, x, x);
	@:dox(hide) public var xxxy (get, never):Vec4; private function get_xxxy() return Vec4.get(x, x, x, y);
	@:dox(hide) public var xxxz (get, never):Vec4; private function get_xxxz() return Vec4.get(x, x, x, z);
	@:dox(hide) public var xxyx (get, never):Vec4; private function get_xxyx() return Vec4.get(x, x, y, x);
	@:dox(hide) public var xxyy (get, never):Vec4; private function get_xxyy() return Vec4.get(x, x, y, y);
	@:dox(hide) public var xxyz (get, never):Vec4; private function get_xxyz() return Vec4.get(x, x, y, z);
	@:dox(hide) public var xxzx (get, never):Vec4; private function get_xxzx() return Vec4.get(x, x, z, x);
	@:dox(hide) public var xxzy (get, never):Vec4; private function get_xxzy() return Vec4.get(x, x, z, y);
	@:dox(hide) public var xxzz (get, never):Vec4; private function get_xxzz() return Vec4.get(x, x, z, z);
	@:dox(hide) public var xyxx (get, never):Vec4; private function get_xyxx() return Vec4.get(x, y, x, x);
	@:dox(hide) public var xyxy (get, never):Vec4; private function get_xyxy() return Vec4.get(x, y, x, y);
	@:dox(hide) public var xyxz (get, never):Vec4; private function get_xyxz() return Vec4.get(x, y, x, z);
	@:dox(hide) public var xyyx (get, never):Vec4; private function get_xyyx() return Vec4.get(x, y, y, x);
	@:dox(hide) public var xyyy (get, never):Vec4; private function get_xyyy() return Vec4.get(x, y, y, y);
	@:dox(hide) public var xyyz (get, never):Vec4; private function get_xyyz() return Vec4.get(x, y, y, z);
	@:dox(hide) public var xyzx (get, never):Vec4; private function get_xyzx() return Vec4.get(x, y, z, x);
	@:dox(hide) public var xyzy (get, never):Vec4; private function get_xyzy() return Vec4.get(x, y, z, y);
	@:dox(hide) public var xyzz (get, never):Vec4; private function get_xyzz() return Vec4.get(x, y, z, z);
	@:dox(hide) public var xzxx (get, never):Vec4; private function get_xzxx() return Vec4.get(x, z, x, x);
	@:dox(hide) public var xzxy (get, never):Vec4; private function get_xzxy() return Vec4.get(x, z, x, y);
	@:dox(hide) public var xzxz (get, never):Vec4; private function get_xzxz() return Vec4.get(x, z, x, z);
	@:dox(hide) public var xzyx (get, never):Vec4; private function get_xzyx() return Vec4.get(x, z, y, x);
	@:dox(hide) public var xzyy (get, never):Vec4; private function get_xzyy() return Vec4.get(x, z, y, y);
	@:dox(hide) public var xzyz (get, never):Vec4; private function get_xzyz() return Vec4.get(x, z, y, z);
	@:dox(hide) public var xzzx (get, never):Vec4; private function get_xzzx() return Vec4.get(x, z, z, x);
	@:dox(hide) public var xzzy (get, never):Vec4; private function get_xzzy() return Vec4.get(x, z, z, y);
	@:dox(hide) public var xzzz (get, never):Vec4; private function get_xzzz() return Vec4.get(x, z, z, z);
	@:dox(hide) public var yxxx (get, never):Vec4; private function get_yxxx() return Vec4.get(y, x, x, x);
	@:dox(hide) public var yxxy (get, never):Vec4; private function get_yxxy() return Vec4.get(y, x, x, y);
	@:dox(hide) public var yxxz (get, never):Vec4; private function get_yxxz() return Vec4.get(y, x, x, z);
	@:dox(hide) public var yxyx (get, never):Vec4; private function get_yxyx() return Vec4.get(y, x, y, x);
	@:dox(hide) public var yxyy (get, never):Vec4; private function get_yxyy() return Vec4.get(y, x, y, y);
	@:dox(hide) public var yxyz (get, never):Vec4; private function get_yxyz() return Vec4.get(y, x, y, z);
	@:dox(hide) public var yxzx (get, never):Vec4; private function get_yxzx() return Vec4.get(y, x, z, x);
	@:dox(hide) public var yxzy (get, never):Vec4; private function get_yxzy() return Vec4.get(y, x, z, y);
	@:dox(hide) public var yxzz (get, never):Vec4; private function get_yxzz() return Vec4.get(y, x, z, z);
	@:dox(hide) public var yyxx (get, never):Vec4; private function get_yyxx() return Vec4.get(y, y, x, x);
	@:dox(hide) public var yyxy (get, never):Vec4; private function get_yyxy() return Vec4.get(y, y, x, y);
	@:dox(hide) public var yyxz (get, never):Vec4; private function get_yyxz() return Vec4.get(y, y, x, z);
	@:dox(hide) public var yyyx (get, never):Vec4; private function get_yyyx() return Vec4.get(y, y, y, x);
	@:dox(hide) public var yyyy (get, never):Vec4; private function get_yyyy() return Vec4.get(y, y, y, y);
	@:dox(hide) public var yyyz (get, never):Vec4; private function get_yyyz() return Vec4.get(y, y, y, z);
	@:dox(hide) public var yyzx (get, never):Vec4; private function get_yyzx() return Vec4.get(y, y, z, x);
	@:dox(hide) public var yyzy (get, never):Vec4; private function get_yyzy() return Vec4.get(y, y, z, y);
	@:dox(hide) public var yyzz (get, never):Vec4; private function get_yyzz() return Vec4.get(y, y, z, z);
	@:dox(hide) public var yzxx (get, never):Vec4; private function get_yzxx() return Vec4.get(y, z, x, x);
	@:dox(hide) public var yzxy (get, never):Vec4; private function get_yzxy() return Vec4.get(y, z, x, y);
	@:dox(hide) public var yzxz (get, never):Vec4; private function get_yzxz() return Vec4.get(y, z, x, z);
	@:dox(hide) public var yzyx (get, never):Vec4; private function get_yzyx() return Vec4.get(y, z, y, x);
	@:dox(hide) public var yzyy (get, never):Vec4; private function get_yzyy() return Vec4.get(y, z, y, y);
	@:dox(hide) public var yzyz (get, never):Vec4; private function get_yzyz() return Vec4.get(y, z, y, z);
	@:dox(hide) public var yzzx (get, never):Vec4; private function get_yzzx() return Vec4.get(y, z, z, x);
	@:dox(hide) public var yzzy (get, never):Vec4; private function get_yzzy() return Vec4.get(y, z, z, y);
	@:dox(hide) public var yzzz (get, never):Vec4; private function get_yzzz() return Vec4.get(y, z, z, z);
	@:dox(hide) public var zxxx (get, never):Vec4; private function get_zxxx() return Vec4.get(z, x, x, x);
	@:dox(hide) public var zxxy (get, never):Vec4; private function get_zxxy() return Vec4.get(z, x, x, y);
	@:dox(hide) public var zxxz (get, never):Vec4; private function get_zxxz() return Vec4.get(z, x, x, z);
	@:dox(hide) public var zxyx (get, never):Vec4; private function get_zxyx() return Vec4.get(z, x, y, x);
	@:dox(hide) public var zxyy (get, never):Vec4; private function get_zxyy() return Vec4.get(z, x, y, y);
	@:dox(hide) public var zxyz (get, never):Vec4; private function get_zxyz() return Vec4.get(z, x, y, z);
	@:dox(hide) public var zxzx (get, never):Vec4; private function get_zxzx() return Vec4.get(z, x, z, x);
	@:dox(hide) public var zxzy (get, never):Vec4; private function get_zxzy() return Vec4.get(z, x, z, y);
	@:dox(hide) public var zxzz (get, never):Vec4; private function get_zxzz() return Vec4.get(z, x, z, z);
	@:dox(hide) public var zyxx (get, never):Vec4; private function get_zyxx() return Vec4.get(z, y, x, x);
	@:dox(hide) public var zyxy (get, never):Vec4; private function get_zyxy() return Vec4.get(z, y, x, y);
	@:dox(hide) public var zyxz (get, never):Vec4; private function get_zyxz() return Vec4.get(z, y, x, z);
	@:dox(hide) public var zyyx (get, never):Vec4; private function get_zyyx() return Vec4.get(z, y, y, x);
	@:dox(hide) public var zyyy (get, never):Vec4; private function get_zyyy() return Vec4.get(z, y, y, y);
	@:dox(hide) public var zyyz (get, never):Vec4; private function get_zyyz() return Vec4.get(z, y, y, z);
	@:dox(hide) public var zyzx (get, never):Vec4; private function get_zyzx() return Vec4.get(z, y, z, x);
	@:dox(hide) public var zyzy (get, never):Vec4; private function get_zyzy() return Vec4.get(z, y, z, y);
	@:dox(hide) public var zyzz (get, never):Vec4; private function get_zyzz() return Vec4.get(z, y, z, z);
	@:dox(hide) public var zzxx (get, never):Vec4; private function get_zzxx() return Vec4.get(z, z, x, x);
	@:dox(hide) public var zzxy (get, never):Vec4; private function get_zzxy() return Vec4.get(z, z, x, y);
	@:dox(hide) public var zzxz (get, never):Vec4; private function get_zzxz() return Vec4.get(z, z, x, z);
	@:dox(hide) public var zzyx (get, never):Vec4; private function get_zzyx() return Vec4.get(z, z, y, x);
	@:dox(hide) public var zzyy (get, never):Vec4; private function get_zzyy() return Vec4.get(z, z, y, y);
	@:dox(hide) public var zzyz (get, never):Vec4; private function get_zzyz() return Vec4.get(z, z, y, z);
	@:dox(hide) public var zzzx (get, never):Vec4; private function get_zzzx() return Vec4.get(z, z, z, x);
	@:dox(hide) public var zzzy (get, never):Vec4; private function get_zzzy() return Vec4.get(z, z, z, y);
	@:dox(hide) public var zzzz (get, never):Vec4; private function get_zzzz() return Vec4.get(z, z, z, z);

}