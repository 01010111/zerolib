package zerolib;

/**
 * ...
 * @author 01010111
 */
class ZArrayUtils
{

	public static function in_array(_object:Dynamic, _array:Array<Dynamic>):Bool
	{
		var _b:Bool = false;
		for (i in 0..._array.length)
		{
			if (_object == _array[i]) _b = true;
		}
		return _b;
	}
	
	public static function get_random(_array:Array<Dynamic>):Int
	{
		return ZMath.randomRangeInt(0, _array.length - 1);
	}
	
}