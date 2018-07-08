package zero.ext;

using zero.ext.ArrayExt;
using zero.ext.FloatExt;

/**
 *  A collection of extension methods for strings
 */
class StringExt
{

	/**
	 *  returns a 2D array of integers from a csv string
	 *  @param csv	input csv string
	 *  @return		Array<Array<Int>>
	 */
	public static inline function csv_to_2d_int_array(csv:String):Array<Array<Int>> return [for (row in csv.split('\n')) row.split(',').strings_to_ints()];
	
	/**
	 *  checks to see if a string contains another string
	 *  @param src		input string
	 *  @param value	string query
	 *  @return			Bool return src.indexOf(value) >= 0
	 */
	public static inline function contains(src:String, value:String):Bool return src.indexOf(value) >= 0;

	/**
	 *  returns a random set of letters with an optional prefix and suffix
	 *  @param string	input string (ignored)
	 *  @param length	length of set
	 *  @param prefix	prefix string
	 *  @param postfix	suffix string
	 */
	public static inline function get_random(string:String, length:Int = 16, prefix:String = '', postfix:String = '')
	{
		var a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#';
		var s = '';
		for (i in 0...length)s += a.charAt(a.length.get_random().to_int());
		return '$prefix$s$postfix';
	}

}