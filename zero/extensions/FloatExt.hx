package zero.extensions;

import zero.utilities.Vec2;
import zero.utilities.Vec4;
import zero.utilities.Color;

using zero.extensions.FloatExt;
using Math;

/**
 *  A collection of extension methods for Floats
 */
class FloatExt
{

	/**
	 *  Returns the degree equivalent to the input radian. ex. Math.PI.rad_to_deg() = 180
	 *  @param rad	input radian
	 *  @return		Float
	 */
	public static inline function rad_to_deg(rad:Float):Float return rad * (180 / Math.PI);

	/**
	 *  Returns the radian equivalent to the input degree. ex. 180.deg_to_rad() == Math.PI = true
	 *  @param deg	input degree
	 *  @return		Float
	 */
	public static inline function deg_to_rad(deg:Float):Float return deg * (Math.PI / 180);

	/**
	 *  Loops input value through a range of minimum and maximum values. ex. 150.cycle(0, 100) = 50
	 *  @param n	input value
	 *  @param min	minimum value (beginning) of cycle
	 *  @param max	maximum value (end) of cycle
	 *  @return		Float
	 */
	public static inline function cycle(n:Float, min:Float, max:Float):Float return((n - min) % (max - min) + (max - min)) % (max - min) + min;

	/**
	 *  Returns a degree between 0 and 360. ex. (-10).get_relative_degree() = 350
	 *  @param n	input angle
	 *  @return		Float
	 */
	public static inline function get_relative_degree(n:Float):Float return (n % 360 + 360) % 360;

	/**
	 * Returns a degree that has the same relative angle as the input angle, but is closest to the second angle. ex. 350.translate_to_nearest_angle(10) = 20
	 * @param a1	input angle in degrees
	 * @param a2	second angle in degrees
	 * @return Float
	 */
	public static inline function translate_to_nearest_angle(a1:Float, a2:Float):Float
	{
		while((a1 - a2).abs() > 180) a1 -= (a1 - a2).sign_of() * 360;
		return a1;
	}

	/**
	 *  Returns the degrees between two angles. ex. 20.degrees_between(-20) = 40
	 *  @param a1	first angle in degrees
	 *  @param a2	second angle in degrees
	 *  @return		Float
	 */
	public static inline function degrees_between(a1:Float, a2:Float):Float return (((a2 - a1).max(a1 - a2) + 180) % 360 - 180).abs();

	/**
	 *  Clamps input value between the minimum and maximum values. ex. 120.clamp(0, 100) = 100
	 *  @param n	input value
	 *  @param min	minimum value
	 *  @param max	maximum value
	 *  @return		Float
	 */
	public static inline function clamp(n:Float, min:Float, max:Float):Float return n.max(min).min(max);

	/**
	 *  returns input value with removed decimal places after places input. ex. 1.135908.normalize(2) = 1.14
	 *  @param n		input value
	 *  @param places	how many places
	 *  @return			Float
	 */
	public static inline function normalize(n:Float, places:Int):Float return (n * 10.pow(places)).round() / 10.pow(places);

	/**
	 *  returns a norm value t of a through b. ex. 10.norm(0, 100) = 0.1
	 *  @param t	input value
	 *  @param a	norm range first index
	 *  @param b	norm range second index
	 *  @return		Float
	 */
	public static inline function norm(t:Float, a:Float, b:Float):Float return ( t - a ) / ( b - a );

	/**
	 *  linear interpolation. ex. 2.lerp(0, 100) = 200;
	 *  @param t	input value
	 *  @param a	lerp range first index
	 *  @param b	lerp range second index
	 *  @return 	Float
	 */
	public static inline function lerp(t:Float, a:Float, b:Float):Float return (1 - t) * a + t * b;

	/**
	 *  Maps a value from one range of values to another, ex: 1.map(0, 2, 20, 30) = 25
	 *  @param t	input value
	 *  @param a0	0 index for first range
	 *  @param b0	1 index for first range
	 *  @param a1	0 index for second range
	 *  @param a1	1 index for second range
	 *  @return		Float
	 */
	public static inline function map(t:Float, a0:Float, b0:Float, a1:Float, b1:Float):Float return t.norm(a0, b0).lerp(a1, b1);

	/**
	 *  snaps value n to a grid. ex. 21.snap_to_grid(10) = 20
	 *  @param n			input value
	 *  @param grid_size	the size of the grid
	 *  @param offset		the offset of the grid
	 *  @param floor		whether or not to use Math.floor() or Math.round(), default false (Math.round())
	 *  @return				Float
	 */
	public static inline function snap_to_grid(n:Float, grid_size:Float, ?offset:Float = 0, ?floor:Bool = false):Float return offset + grid_size * (floor ? (n / grid_size).floor() : (n / grid_size).round()); 

	/**
	 *  gets a random number from a range of numbers. ex. 10.get_random() = a number between 0 and 10
	 *  @param def_max	input value is the assumed (default) maximum number in the desired range
	 *  @param min		the minimum number in the desired range
	 *  @param max		overrides input number for the maximum number in the desired range (input number is ignored)
	 *  @return			Float
	 */
	public static inline function get_random(def_max:Float, min:Float = 0, ?max:Float):Float return min + Math.random() * ((max == null ? def_max : max) - min);

	/**
	 *  returns the sign (-1, 0, 1) of a number
	 *  @param n	input value
	 *  @return		Int
	 */
	public static inline function sign_of(n:Float):Int return n > 0 ? 1 : n < 0 ? -1 : 0;

	/**
	 *  returns an Int in the place of a Float. ex. 10.1.to_int() = 10
	 *  @param n	input Float
	 *  @return		Int
	 */
	public static inline function to_int(n:Float):Int return Std.int(n);

	/**
	 *  returns half of the input
	 *  @param n	input float
	 *  @return		Float return n * 0.5
	 */
	public static inline function half(n:Float):Float return n * 0.5;

	/**
	 *  returns quarter of the input
	 *  @param n	input float
	 *  @return		Float return n * 0.25
	 */
	public static inline function quarter(n:Float):Float return n * 0.25;

	/**
	 * Converts an 0xRRGGBBAA Int to a float array suitable for passing to shaders
	 * @param n	input value
	 * @return Array<Float>
	 */
	public static inline function to_vec4(n:Float):Array<Float>
	{
		var out:Color = Color.get().from_int32(n.to_int()); 
		return cast out;
	}

	/**
	 *  returns a Vector describing a vector of given angle and length. ex. 270.vector_from_angle(100) == new Vector(0, -100) = true
	 *  @param a	the angle in degrees of desired vector
	 *  @param len	the length of the desired vector
	 *  @return		Vector
	 */
	public static inline function vector_from_angle(a:Float, len:Float):Vec2 return Vec2.get(a.deg_to_rad().cos() * len, a.deg_to_rad().sin() * len);

}