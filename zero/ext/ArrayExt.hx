package zero.ext;

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

}