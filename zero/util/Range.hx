package zero.util;

/**
 *  @author 01010111
 */
using zero.ext.FloatExt;

class Range
{

	public var min:Float;
	public var max:Float;

	public function new(min:Float = 0, max:Float = 1)
	{
		this.min = min;
		this.max = max;
	}

	public inline function get_random_in_range():Float return max.get_random(min);

}