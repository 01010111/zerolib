package zero.extensions;

using zero.extensions.ArrayExt;
using zero.extensions.FloatExt;
using zero.extensions.StringExt;
using Math;

/**
 *  A collection of extension methods for strings
 * 
 * **Usage:**
 * 
 * - use this extension by adding this where you normally import modules: `using zero.extensions.StringExt;`
 * - now you can use any of these functions on different arrays: `'ABCDEFG'.get_random(2); // 'GB'`
 * - or use all of the extensions in this library by adding: `using zero.extensions.Tools;`
 */
class StringExt
{

	/**
	 *  returns a 2D array of integers from a csv string
	 */
	public static inline function csv_to_2d_int_array(csv:String):Array<Array<Int>> return [for (row in csv.split('\n')) row.split(',').strings_to_ints()];

	/**
	 *  returns an array of integers from a csv string
	 */
	public static inline function csv_to_int_array(csv:String):Array<Int> return [for (row in csv.split('\n')) row.split(',').strings_to_ints()].flatten();
	
	/**
	 *  checks to see if a string contains another string
	 */
	public static inline function contains(src:String, value:String):Bool return src.indexOf(value) >= 0;

	/**
	 * Returns a set of letters from an input string, ordered returns a random chunk of the input string
	 */
	public static inline function get_random(string:String, length:Int = 1, ordered:Bool = false):String
	{
		if (!ordered) return [for (i in 0...length) string.charAt(string.length.get_random().floor())].join(''); 
		length = length.min(string.length).to_int();
		return string.substr(string.length.min(string.length - length).get_random().to_int(), length);
	}

	/**
	 * Returns an object parsed from JSON
	 */
	public static inline function parse_json(string:String):Dynamic {
		return haxe.Json.parse([for (line in string.split('\n')) line.split('//')[0]].join('\n'));
	}

	public static inline function capitalize_first_letter(string:String):String {
		var chars = string.split('');
		chars[0] = chars[0].toUpperCase();
		return chars.join('');
	}

	public static inline function capitalize_first_letter_of_every_word(string:String):String {
		var words = string.split(' ');
		for (i in 0...words.length) words[i] = words[i].capitalize_first_letter();
		return words.join(' ');
	}

}