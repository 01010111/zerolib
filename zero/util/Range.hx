package zero.util;

using zero.ext.FloatExt;

/**
 *  A Range class with a min and max
 */
class Range
{

	public var min:Float;
	public var max:Float;

	/**
	 *  Creates a new Range object with min and max values
	 *  @param min	minimum value
	 *  @param max	maximum value
	 */
	public function new(min:Float = 0, max:Float = 1)
	{
		this.min = min;
		this.max = max;
	}

	/**
	 *  returns whether or not the provided value is in the range of this object
	 *  @param value	input value
	 *  @return			Bool
	 */
	public inline function in_range(value:Float):Bool return value >= min && value <= max;

	/**
	 *  Returns a random float within this range
	 *  @return	Float
	 */
	public inline function get_random_in_range():Float return max.get_random(min);

	/**
	 *  returns a normalized value (0-1) given the input is within this range
	 *  @param value	input value
	 *  @return			Float
	 */
	public inline function normalize(value:Float):Float return value.map(min, max, 0, 1);

	/**
	 *  returns a denormalized value (min-max) given the input is 0-1
	 *  @param value	input value
	 *  @return			Float
	 */
	public inline function denormalize(value:Float):Float return value.map(0, 1, min, max);

}