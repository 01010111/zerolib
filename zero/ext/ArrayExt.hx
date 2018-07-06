package zero.ext;

using zero.ext.FloatExt;

/**
 *  A collection of extension methods for Arrays (some of these are only usable on arrays containing specific types)
 */
class ArrayExt 
{

	/**
	 *  Converts an array of strings to an array of itegers
	 *  @param array	input array
	 *  @return			Array<Int>
	 */
	public static inline function strings_to_ints(array:Array<String>):Array<Int> return [for (s in array) Std.parseInt(s)];

	/**
	 *  Checks whether or not an array contains a value or object
	 *  @param array	input array
	 *  @param value	value to check
	 *  @return			Bool
	 */
	public static inline function contains(array:Array<Dynamic>, value:Dynamic):Bool return array.indexOf(value) >= 0;

	/**
	 *  Returns a random element from an array
	 *  @param array	input array
	 *  @return			Dynamic
	 */
	public static inline function get_random(array:Array<Dynamic>):Dynamic return array[array.length.get_random().to_int()];

   	/**
   	 *  shuffles an array in place and returns it
   	 *  @param array	input array
   	 *  @return			Array<T>
   	 */
   	public static function shuffle<T>(array:Array<T>):Array<T>
	{
		for (i in 0...array.length)
		{
			var j = array.length.get_random().to_int();
			var a = array[i];
			var b = array[j];
			array[i] = b;
			array[j] = a;
		}
		return array;
	}

	/**
	 *  Merges a second array (of the same type) into the first array
	 *  @param a1	first array
	 *  @param a2	second array
	 *  @return		Array<T>
	 */
	public static function merge<T>(a1:Array<T>, a2:Array<T>):Array<T>
	{
		for (o in a2) a1.push(o);
		return a1;
	}

}