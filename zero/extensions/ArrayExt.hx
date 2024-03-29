package zero.extensions;

import zero.utilities.IntPoint;

using zero.extensions.FloatExt;
using zero.extensions.ArrayExt;
using Math;

/**
 *  A collection of extension methods for Arrays (some of these are only usable on arrays containing specific types)
 * 
 * **Usage:**
 * 
 * - use this extension by adding this where you normally import modules: `using zero.extensions.ArrayExt;`
 * - now you can use any of these functions on different arrays: `[0, 1, 2, 3].get_random(); // 2`
 * - or use all of the extensions in this library by adding: `using zero.extensions.Tools;`
 */
class ArrayExt 
{

	/**
	 *  Converts an array of strings to an array of itegers
	 */
	public static inline function strings_to_ints(array:Array<String>):Array<Int> return [for (s in array) Std.parseInt(s)];

	/**
	 *  Converts an array of strings to an array of itegers
	 */
	public static inline function strings2D_to_ints(array:Array<Array<String>>):Array<Array<Int>> return [for (row in array) [for (s in row) Std.parseInt(s)]];

	 /**
	 * Returns the last element in an array
	 */
	public static inline function last<T>(a:Array<T>):T return a[a.length - 1];

	/**
	 *  Returns a random element from an array
	 */
	public static inline function get_random<T>(array:Array<T>):T return array[array.length.get_random().to_int()];

   	/**
   	 *  shuffles an array in place and returns it
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
	 */
	public static function merge<T>(a1:Array<T>, a2:Array<T>):Array<T>
	{
		for (o in a2) a1.push(o);
		return a1;
	}

	/**
	 * Flattens a 2D Array into a 1D Array
	 */
	public static inline function flatten<T>(a:Array<Array<T>>):Array<T> return [for (row in a) for (e in row) e];

	/**
	 * Expands a 1D Array into a 2D Array
	 */
	public static inline function expand<T>(a:Array<T>, row_width:Int):Array<Array<T>>
	{
		var out = [];
		for (i in 0...a.length)
		{
			if (i % row_width == 0) out.push([]);
			out[out.length - 1].push(a[i]);
		}
		return out;
	}

	/**
	 * Uses a flood-fill algorithm to change equal values contiguous to the input coordinates to a new value
	 */
	public static function flood_fill_2D(array:Array<Array<Dynamic>>, x:Int, y:Int, value:Dynamic)
	{
		if (x < 0 || y < 0 || y >= array.length || x >= array[y].length) return;
		var target_value = array[y][x];
		var validate = function(x:Int, y:Int) return !(x < 0 || y < 0 || y >= array.length || x >= array[y].length) && array[y][x] == target_value;
		var queue:Array<{ x:Int, y:Int }> = [{ x: x, y: y }];
		while (queue.length > 0)
		{
			var point = queue.shift();
			array[point.y][point.x] = value;

			if (validate(point.x, point.y - 1)) queue.push({ x: point.x, y: point.y - 1 });
			if (validate(point.x, point.y + 1)) queue.push({ x: point.x, y: point.y + 1 });
			if (validate(point.x - 1, point.y)) queue.push({ x: point.x - 1, y: point.y });
			if (validate(point.x + 1, point.y)) queue.push({ x: point.x + 1, y: point.y });
		}
	}

	/**
	 * Uses a flood-fill algorithm to change equal values contiguous to the input position to a new value
	 */
	public static function flood_fill_1D(array:Array<Dynamic>, pos:Int, value:Dynamic)
	{
		if (pos < 0 || pos > array.length) return;
		var target_value = array[pos];
		var validate = function(pos:Int) return !(pos < 0 || pos > array.length) && array[pos] == target_value;
		var queue:Array<Int> = [pos];
		while (queue.length > 0)
		{
			var pos = queue.shift();
			array[pos] = value;

			if (validate(pos - 1)) queue.push(pos - 1);
			if (validate(pos + 1)) queue.push(pos + 1);
		}
	}

	/**
	 * Uses a flood-fill type algorithm to generate a heat map from the coordinates
	 */
	public static function heat_map(array:Array<Array<Dynamic>>, x:Int, y:Int, max_value:Int = -1):Array<Array<Int>>
	{
		if (x < 0 || y < 0 || y >= array.length || x >= array[y].length) return [];
		var value = -1;
		var map = [for (row in array) [for (v in row) 0]];
		var min:Int = 0;
		var target_value = array[y][x];
		var validate = function(x:Int, y:Int) return !(x < 0 || y < 0 || y >= array.length || x >= array[y].length) && array[y][x] == target_value && map[y][x] == 0;
		var queue:Array<{ x:Int, y:Int, value:Int }> = [{ x: x, y: y, value: value }];
		while (queue.length > 0)
		{
			var point = queue.shift();
			map[point.y][point.x] = point.value;
			min = point.value.min(min).round(); 

			if (validate(point.x, point.y - 1)) queue.push({ x: point.x, y: point.y - 1, value: point.value - 1 });
			if (validate(point.x, point.y + 1)) queue.push({ x: point.x, y: point.y + 1, value: point.value - 1 });
			if (validate(point.x - 1, point.y)) queue.push({ x: point.x - 1, y: point.y, value: point.value - 1 });
			if (validate(point.x + 1, point.y)) queue.push({ x: point.x + 1, y: point.y, value: point.value - 1 });
		}

		var diff = max_value < 0 ? -min + 1 : -min + 1 - (-min - max_value);
		for (j in 0...map.length) for (i in 0...map[j].length) if (map[j][i] != 0) map[j][i] = (map[j][i] + diff).max(0).round();

		return map;
	}

	/**
	 * get a value from a 2D array with coordinates
	 */
	public static function get_xy(array:Array<Array<Dynamic>>, x:Int, y:Int):Dynamic
	{
		y = y.max(0).min(array.length - 1).floor();
		x = x.max(0).min(array[y].length - 1).floor();
		return array[y][x];
	}

	/**
	 * set a value in a 2D array
	 */
	public static function set_xy(array:Array<Array<Dynamic>>, x:Int, y:Int, value:Dynamic)
	{
		y = y.max(0).min(array.length - 1).floor();
		x = x.max(0).min(array[y].length - 1).floor();
		array[y][x] = value;
	}

	/**
	 * Return the value closest to the middle of the array
	 */
	public static function median(array:Array<Dynamic>):Dynamic
	{
		return array[array.length.half().floor()];
	}

	/**
	 * Checks to see if two arrays are equal
	 */
	public static function equals(a1:Array<Dynamic>, a2:Array<Dynamic>):Bool
	{
		if (a1.length != a2.length) return false;
		for (i in 0...a1.length) if (a1[i] != a2[i]) return false;
		return true;
	}

	/**
	 * Remove duplicates from given array and return the array
	 */
	public static function remove_duplicates<T>(arr:Array<T>):Array<T> {
		var unique = [];
		for (item in arr) if (unique.indexOf(item) < 0) unique.push(item);
		return arr = unique;
	}

	/**
	 * Returns a "chunk" of a 2D array from given coordinates, width and height
	 */
	public static function chunk<T>(arr:Array<Array<T>>, x:Int, y:Int, w:Int, h:Int):Array<Array<T>> {
		if (arr.length < y + h || arr[0].length < x + w || x < 0 || y < 0) return [];
		var out = [for (j in 0...h) []];
		for (j in 0...h) for (i in 0...w) out[j][i] = arr[y + j][x + i];
		return out;
	}

	/**
	 *	Fills a 2D array with a specific value
	 */
	public static function fill<T>(arr:Array<Array<T>>, v:T) {
		for (j in 0...arr.length) for (i in 0...arr[j].length) arr[j][i] = v;
	}

	public static function push_multi<T>(arr:Array<T>, ...values:T) {
		for (value in values) arr.push(value);
	}

}