package zero.ext;

import flixel.math.FlxPoint;

using zero.ext.FloatExt;
using Math;

/**
 *  @author 01010111 
 */
class FloatExt
{

    /**
     *  Returns the degree equivalent to the input radian. ex. Math.PI.rad_to_deg() = 180
     *  @param rad - input radian
     *  @return Float
     */
    inline public static function rad_to_deg(rad:Float):Float
    {
        return rad * (180 / Math.PI);
    }

    /**
     *  Returns the radian equivalent to the input degree. ex. 180.deg_to_rad() == Math.PI = true
     *  @param deg - input degree
     *  @return Float
     */
    inline public static function deg_to_rad(deg:Float):Float
    {
        return deg * (Math.PI / 180);
    }

    /**
     *  Loops input value through a range of minimum and maximum values. ex. 150.cycle(0, 100) = 50
     *  @param n - input value
     *  @param min - minimum value (beginning) of cycle
     *  @param max - maximum value (end) of cycle
     *  @return Float
     */
    inline public static function cycle(n:Float, min:Float, max:Float):Float
	{
    	return((n - min) % (max - min) + (max - min)) % (max - min) + min;
	}

    /**
     *  Returns a degree between 0 and 360. ex. (-10).get_relative_degree() = 350
     *  @param n - input degree
     *  @return Float
     */
    inline public static function get_relative_degree(n:Float):Float
    {
        return (n % 360 + 360) % 360;
    }

    /**
     *  Returns the degrees between two angles. ex. 20.degrees_between(-20) = 40
     *  @param a1 - first angle in degrees
     *  @param a2 - second angle in degrees
     *  @return Float
     */
    inline public static function degrees_between(a1:Float, a2:Float):Float
    {
        return (((a2 - a1).max(a1 - a2) + 180) % 360 - 180).abs();
    }

    /**
     *  Clamps input value between the minimum and maximum values. ex. 120.clamp(0, 100) = 100
     *  @param n - input value
     *  @param min - minimum value
     *  @param max - maximum value
     *  @return Float
     */
    inline public static function clamp(n:Float, min:Float, max:Float):Float
    {
        return n.max(min).min(max);
    }

    /**
     *  returns input value with removed decimal places after places input. ex. 1.135908.normalize(2) = 1.14
     *  @param n - input value
     *  @param places - how many places
     *  @return Float
     */
    inline public static function normalize(n:Float, places:Int):Float
	{
        return (n * 10.pow(places)).round() / 10.pow(places);
	}

    /**
     *  returns a norm value t of a through b. ex. 10.norm(0, 100) = 0.1
     *  @param   t input value
     *  @param   a norm range first index
     *  @param   b norm range second index
     *  @return  Float
     */
    inline public static function norm(t:Float, a:Float, b:Float):Float
    {
        return ( t - a ) / ( b - a );
    }

    /**
     *  linear interpolation. ex. 2.lerp(0, 100) = 200;
     *  @param   t input value
     *  @param   a lerp range first index
     *  @param   b lerp range second index
     *  @return  Float
     */
    inline public static function lerp(t:Float, a:Float, b:Float):Float
    {
        return (1 - t) * a + t * b;
    }

    /**
     *  Maps a value from one range of values to another, ex: 1.map(0, 2, 20, 30) = 25
     *  @param   t input value
     *  @param   a0 0 index for first range
     *  @param   b0 1 index for first range
     *  @param   a1 0 index for second range
     *  @param   a1 1 index for second range
     *  @return  Float
     */
    inline public static function map(t:Float, a0:Float, b0:Float, a1:Float, b1:Float):Float
    {
        return t.norm(a0, b0).lerp(a1, b1);
    }

    /**
     *  snaps value n to a grid. ex. 21.snap_to_grid(10) = 20
     *  @param n - input value
     *  @param grid_size - the size of the grid
     *  @param offset - the offset of the grid
     *  @param floor - whether or not to use Math.floor() or Math.round(), default false (Math.round())
     *  @return Float
     */
    inline public static function snap_to_grid(n:Float, grid_size:Float, ?offset:Float = 0, ?floor:Bool = false):Float
    {
        return offset + grid_size * (floor ? (n / grid_size).floor() : (n / grid_size).round()); 
    }

    /**
     *  gets a random number from a range of numbers. ex. 10.get_random() = a number between 0 and 10
     *  @param def_max - input value is the assumed (default) maximum number in the desired range
     *  @param min - the minimum number in the desired range
     *  @param max - overrides input number for the maximum number in the desired range (input number is ignored)
     *  @return Float
     */
    inline public static function get_random(def_max:Float, min:Float = 0, ?max:Float):Float
    {
        return min + Math.random() * ((max == null ? def_max : max) - min);
    }

	/**
	 *  returns the sign (-1, 0, 1) of a number
	 *  
	 *  @param   n - input value
	 *  @return  Int
	 */
	inline public static function sign_of(n:Float):Int
	{
		if (n > 0) return 1;
		if (n < 0) return -1;
		return 0;
	}

    /**
     *  returns an Int in the place of a Float. ex. 10.1.to_int() = 10
     *  @param n - input Float
     *  @return Int
     */
    inline public static function to_int(n:Float):Int
    {
        return Std.int(n);
    }

    /**
     *  returns a FlxPoint describing a vector of given angle and length. ex. 270.vector_from_angle(100) == FlxPoint.get(0, -100) = true
     *  @param a - the angle in degrees of desired vector
     *  @param len - the length of the desired vector
     *  @return FlxPoint
     */
    inline public static function vector_from_angle(a:Float, len:Float):FlxPoint
    {
        return FlxPoint.get(a.deg_to_rad().cos() * len, a.deg_to_rad().sin() * len);
    }

}