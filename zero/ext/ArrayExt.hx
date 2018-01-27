package zero.ext;

using zero.ext.FloatExt;

/**
 *  @author 01010111 
 */
class ArrayExt 
{

    inline public static function strings_to_ints(array:Array<String>):Array<Int>
    {
        var a = [];
        for (s in array) a.push(Std.parseInt(s));
        return a;
    }

	inline public static function contains(array:Array<Dynamic>, value:Dynamic):Bool
	{
		var b = false;
		for (i in 0...array.length)
		{
			if (value == array[i]) b = true;
		}
		return b;
	}

	inline public static function get_random(array:Array<Dynamic>):Dynamic
	{
		return array[array.length.get_random().to_int()];
	}

}