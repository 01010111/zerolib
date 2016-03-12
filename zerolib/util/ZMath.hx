package zerolib.util;

import flixel.math.FlxPoint;

/**
 * Various useful math utilities for use with HaxeFlixel. 
 * See notes in methods for more detailed information.
 * @author x01010111
 */

class ZMath 
{
	
	/**
	 * Takes radian and returns it in Degrees
	 * @param	radian	The radian to be converted to degrees
	 * @return	Float the Radian as Degrees
	 */
	public static function radToDeg(radian:Float):Float 
	{ 
		/*
		 * One radian is equal to a length along the circumference of a
		 * circle that is equal to the radius of the circle.
		 * ~3.142radians is equal to 180 degrees. Multiply that by 2 and
		 * you'll see that 360 degrees = 2 * PI * radians, similarly
		 * the equation for the circumference of a circle is
		 * circumference = 2 * PI * radius
		 */
		return radian * (180 / Math.PI); 
	}
	
	/**
	 * Takes degrees and returns it as a Radian
	 * @param	degree	The Degree to be converted to a Radian
	 * @return	Float the Radian as Degrees
	 */
	public static function degToRad(degree:Float):Float 
	{ 
		/*
		 * See notes for radToDeg for the relationship between
		 * degrees and radians
		 */
		return degree * (Math.PI / 180); 
	}
	
	/**
	 * Takes any angle and returns an Integer between 0 - 359, 
	 * so an angle of 370 degrees would return 10
	 * @param	angle	Original angle in degrees
	 * @return	Float Relative angle (0-359)
	 */
	public static function toRelativeAngle(angle:Float):Float 
	{
		/*
		 * First get the remainder of the result of dividing angle by 360
		 * Then, in case the result is negative, add 360 and repeat to get
		 * a result always between 0 and 360;
		 */
		return (angle % 360 + 360) % 360; 
	}
	
	/**
	 * Takes X and Y velocities and returns actual speed
	 * @param	VX	Horizontal Velocity
	 * @param	VY	Vertical Velocity
	 * @return	Float Vector speed
	 */
	public static function vectorVelocity(VX:Float, VY:Float):Float 
	{ 
		/*
		 * Uses Pythagorean theorem: 
		 * c (vector velocity) = the square root of 
		 * a (x velocity) squared plus b (y velocity) squared
		 */
		return Math.sqrt(Math.pow(VX, 2) + Math.pow(VY, 2)); 
	}
	
	/**
	 * Basic distance between two Points (as Floats)
	 * @param	x1	X Value of first Point
	 * @param	y1 	Y value of first Point
	 * @param	x2	X Value of second Point
	 * @param	y2	Y value of second Point
	 * @return	Float The distance between the Two Points
	 */
	public static function distance(p1:FlxPoint, p2:FlxPoint):Float 
	{ 
		/*
		 * Similar to finding vector velocity, uses Pythagorean theorem:
		 * c (distance) = the square root of the difference of the two x
		 * points squared plus the difference of the two y points squared.
		 */
		return Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2)); 
	}
	
	/**
	 *  Returns an angle from current Velocity (or difference between two Points)
	 * @param	vX	Horizontal Velocity
	 * @param	vY	Vertical Velocity
	 * @return	Int Vector Angle in Degrees
	 */
	public static function angleFromVelocity(vX:Float, vY:Float):Float 
	{ 
		/*
		 * Uses the arctangent function to find the angle between the current
		 * point of an object and the velocity of the object, then converts
		 * the result from radians to degrees.
		 */
		return toRelativeAngle(radToDeg(Math.atan2(vY, vX))); 
	}
	
	/**
	 * Finds the angle (in degrees) between two Points
	 * @param	x1	X Value of first Point
	 * @param	y1 	Y value of first Point
	 * @param	x2	X Value of second Point
	 * @param	y2	Y value of second Point
	 * @return	Float The angle between the Two Points
	 */
	public static function angleBetween(p1:FlxPoint, p2:FlxPoint):Float 
	{ 
		/*
		 * Similar to finding the angle from velocity;
		 * Uses the arctangent function to find the angle between two points
		 * Then converts the result from radians to degrees.
		 */
		return radToDeg(Math.atan2(p2.y - p1.y, p2.x - p1.x)); 
	}
	
	/**
	 * Returns a vector from angle and speed
	 * @param	angle	What angle you want to move towards
	 * @param	speed	The speed at which you want to move
	 * @return	FlxPoint The Velocity at the correct angle and speed
	 */
	public static function velocityFromAngle(angle:Float, speed:Float):FlxPoint
	{
		var a:Float = degToRad(angle);
		return FlxPoint.get(Math.cos(a) * speed, Math.sin(a) * speed);
	}
	
	/**
	 * Takes a minimum and maximum Float and returns a random value bewteen them, 
	 * leave blank to return a value between -1 and 1
	 * @param	MIN	Minimum desired result
	 * @param	MAX	Maximum desired result
	 */
	public static function randomRange(?MIN:Float = -1, ?MAX:Float = 1):Float
	{
		return MIN + Math.random() * (MAX - MIN);
	}
	
	/**
	 * Takes a minimum and maximum Float and returns a random integer bewteen them, 
	 * leave blank to return a value between -1 and 1
	 * @param	MIN	Minimum desired result
	 * @param	MAX	Maximum desired result
	 */
	public static function randomRangeInt(?MIN:Float = -1, ?MAX:Float = 1):Int
	{
		return Math.round(MIN + Math.random() * (MAX - MIN));
	}
	
	/**
	 * Places a child relative to a parent using degrees and angle from the center Point
	 * @param	CenterX Horizontal value of parent
	 * @param	CenterY Vertical value of parent
	 * @param	ANGLE	Angle from parent
	 * @param	RADIUS	Radius/Distance from parent
	 * @return	FlxPoint Position of child
	 */
	public static function placeOnCircle(CENTER:FlxPoint, ANGLE:Float, RADIUS:Float):FlxPoint
	{
		var a:Float = degToRad(ANGLE);
		return FlxPoint.get(CENTER.x + RADIUS * Math.cos(a), CENTER.y + RADIUS * Math.sin(a));
	}
	
	/**
	 * Returns a point half-way between two points
	 * @param	x1 First horizontal value
	 * @param	y1 First vertical value
	 * @param	x2 Second horizontal value
	 * @param	y2 Seconds vertical value
	 * @param	percent	(optional)
	 * @return
	 */
	public static function getMidPoint(p1:FlxPoint, p2:FlxPoint, percent:Float = 50):FlxPoint 
	{ 
		return FlxPoint.get(p1.x + (p2.x - p1.x) / (100 / percent), p1.y + (p2.y - p1.y) / (100 / percent)); 
	}
	
	/**
	 * 
	 * @param	n Input Number.
	 * @param	places Round to this many places.
	 * @return
	 */
	public static function roundToDec(n:Float, places:Int):Float
	{
		return Math.round(n * Math.pow(10, places)) / Math.pow(10, places);
	}
	
	/**
	 * 
	 * @param	n
	 * @param	min
	 * @param	max
	 * @return
	 */
	public static function norm(n:Float, min:Float, max:Float):Float
	{
		return (n - min) / (max - min);
	}
	
	/**
	 * 
	 * @param	norm
	 * @param	min
	 * @param	max
	 * @return
	 */
	public static function lerp(norm:Float, min:Float, max:Float):Float
	{
		return (max - min) * norm + min;
	}
	
	/**
	 * 
	 * @param	n initial value
	 * @param	min1 the minimum number of the source
	 * @param	max1 the maximum number of the source
	 * @param	min2 the minimum number of the destination
	 * @param	max2 the maximum number of the destination
	 * @return	Float the mapped value
	 */
	public static function map(n:Float, min1:Float, max1:Float, min2:Float, max2:Float):Float
	{
		return lerp(norm(n, min1, max1), min2, max2);
	}
	
	/**
	 * 
	 * @param	x initial x value
	 * @param	y initial y value
	 * @param	min1 the minimum number of the source
	 * @param	max1 the maximum number of the source
	 * @param	min2 the minimum number of the destination
	 * @param	max2 the maximum number of the destination
	 * @return	FlxPoint the new mapped point
	 */
	public static function mapPoint(x:Float, y:Float, min1:Float, max1:Float, min2:Float, max2):FlxPoint
	{
		return FlxPoint.get(lerp(norm(x, min1, max1), min2, max2), lerp(norm(y, min1, max1), min2, max2));
	}
	
	/**
	 * Clamps a value to fall between a minimum and maximum value
	 * @param	n initial value
	 * @param	min the minimum value
	 * @param	max the maximum value
	 * @return	Float the clamped value
	 */
	public static function clamp(n:Float, min:Float, max:Float):Float
	{
		return Math.min(Math.max(n, min), max);
	}
	
	/**
	 * 
	 * @param	n
	 * @param	gridSize
	 * @return
	 */
	public static function snapToGrid(n:Float, gridSize:Int):Int
	{
		return Math.round(n / gridSize) * gridSize;
	}
	
	public static function quickTween(v:Float, to:Float, factor:Float = 0.1):Float
	{
		return v += (to - v) * factor;
	}
	
	public static function quickTweenPoint(p:FlxPoint, to:FlxPoint, factor:Float = 0.1):FlxPoint
	{
		return FlxPoint.get(quickTween(p.x, to.x, factor), quickTween(p.y, to.y, factor));
	}
	
	public static function chanceRoll(_percentage:Float = 50):Bool
	{
		return Math.random() < _percentage / 100;
	}
	
}