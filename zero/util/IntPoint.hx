package zero.util;

import flixel.math.FlxPoint;

using zero.ext.FloatExt;

/**
 *  A Point containing x and y values as Ints
 */
class IntPoint
{

	public var x:Int;
	public var y:Int;

	/**
	 *  Creates a new IntPoint with x and y coordinates
	 *  @param x	x coordinate
	 *  @param y	y coordinate
	 */
	public function new(x:Int = 0, ?y:Int) set(x, y);

	/**
	 *  Sets x and y coordinates
	 *  @param x	x coordinate
	 *  @param y	y coordinate
	 */
	public function set(x:Int = 0, ?y:Int)
	{
		this.x = x;
		this.y = y == null ? x : y;
	}

	/**
	 *  Compares an IntPoint with this
	 *  @param ip	input IntPoint
	 *  @return		Bool
	 */
	public inline function compare(ip:IntPoint):Bool return (ip.x == x && ip.y == y);
	
	/**
	 *  Adds an IntPoint to this
	 *  @param ip	input IntPoint
	 */
	public inline function add_to(ip:IntPoint) set(x + ip.x, y + ip.y);
	
	/**
	 *  Returns a copy of this IntPoint
	 *  @return	IntPoint
	 */
	public inline function copy():IntPoint return new IntPoint(x, y);
	
	/**
	 *  Copies x and y coordinates from FlxPoint, translating them to Ints
	 *  @param p	input point
	 */
	public inline function from_flx_point(p:FlxPoint) set(p.x.to_int(), p.y.to_int());

	/**
	 *  returns a new FlxPoint with same coordinates
	 *  @return	FlxPoint
	 */
	public inline function to_flx_point():FlxPoint return FlxPoint.get(x, y);

	/**
	 *  Adds two IntPoints and returns a new IntPoint of their sum
	 *  @param ip1	input IntPoint 1
	 *  @param ip2	input IntPoint 2
	 *  @return		IntPoint
	 */
	public static inline function add(ip1, ip2):IntPoint return new IntPoint(ip1.x + ip2.x, ip1.y + ip2.y);

}