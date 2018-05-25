package zero.ext;

using zero.ext.ArrayExt;
using zero.ext.FloatExt;

/**
 *  @author 01010111 
 */
class StringExt
{

    /**
     *  returns a 2D array of integers from a csv string
     *  @param csv - 
     *  @return Array<Array<Int>>
     */
    inline public static function csv_to_2d_int_array(csv:String):Array<Array<Int>>
    {
        var a:Array<Array<Int>> = [];
        var rows = csv.split('\n');
        for (row in rows) a.push(row.split(',').strings_to_ints());
        return a;
    }

	inline public static function get_random(string:String, length:Int = 16, prefix:String = '', postfix:String = '')
	{
		var a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#';
		var s = '';
		for (i in 0...length)s += a.charAt(a.length.get_random().to_int());
		return '$prefix$s$postfix';
	}

	inline public static function contains(src:String, value:String):Bool
	{
		return src.indexOf(value) >= 0;
	}

}