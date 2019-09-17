package zero.extensions;

import zero.utilities.IntPoint;

using zero.extensions.FloatExt;
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
	 *  @param array input array
	 *  @return Array<Int>
	 */
	public static inline function strings_to_ints(array:Array<String>):Array<Int> return [for (s in array) Std.parseInt(s)];

	/**
	 *  Checks whether or not an array contains a value or object
	 *  @param array input array
	 *  @param value value to check
	 *  @return	Bool
	 */
	public static inline function contains(array:Array<Dynamic>, value:Dynamic):Bool return array.indexOf(value) >= 0;

	/**
	 * Returns the last element in an array
	 * @param a	input array
	 * @return <T>
	 */
	public static inline function last(a:Array<Dynamic>):Dynamic return a[a.length - 1];

	/**
	 *  Returns a random element from an array
	 *  @param array input array
	 *  @return	Dynamic
	 */
	public static inline function get_random(array:Array<Dynamic>):Dynamic return array[array.length.get_random().to_int()];

   	/**
   	 *  shuffles an array in place and returns it
   	 *  @param array input array
   	 *  @return	Array<T>
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
	 *  @param a1 first array
	 *  @param a2 second array
	 *  @return Array<T>
	 */
	public static function merge<T>(a1:Array<T>, a2:Array<T>):Array<T>
	{
		for (o in a2) a1.push(o);
		return a1;
	}

	/**
	 * Flattens a 2D Array into a 1D Array
	 * @param a	input array
	 * @return Array<T>
	 */
	public static inline function flatten<T>(a:Array<Array<T>>):Array<T> return [for (row in a) for (e in row) e];

	/**
	 * Expands a 1D Array into a 2D Array
	 * @param a	input array
	 * @param row_width	how many values per row
	 * @return Array<Array<T>>
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
	 * @param array	input array
	 * @param x x coordinate
	 * @param y	y coordinate
	 * @param value new value
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
	 * @param array input array
	 * @param pos index position	
	 * @param value new value
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
	 * @param array input array
	 * @param x x coordinate
	 * @param y y coordinate
	 * @param max_value max heat value, -1 will find the max value based on the minimum result
	 * @return Array<Array<Int>>
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
	 * @param array input array
	 * @param x x coordinate
	 * @param y y coordinate
	 * @return Dynamic
	 */
	public static function get_xy(array:Array<Array<Dynamic>>, x:Int, y:Int):Dynamic
	{
		y = y.max(0).min(array.length - 1).floor();
		x = x.max(0).min(array[y].length - 1).floor();
		return array[y][x];
	}

	/**
	 * set a value in a 2D array
	 * @param array input array
	 * @param x x coordinate
	 * @param y y coordinate
	 * @param value input value
	 */
	public static function set_xy(array:Array<Array<Dynamic>>, x:Int, y:Int, value:Dynamic)
	{
		y = y.max(0).min(array.length - 1).floor();
		x = x.max(0).min(array[y].length - 1).floor();
		array[y][x] = value;
	}

	/**
	 * Return the value closest to the middle of the array
	 * @param array input array
	 * @return Dynamic
	 */
	public static function median(array:Array<Dynamic>):Dynamic
	{
		return array[array.length.half().floor()];
	}

	/**
	 * Runs A* algorithm over given array
	 * @param array input array
	 * @param options
	 * @return Array<IntPoint>
	 */
	public static function a_star(array:Array<Array<Int>>, options:AStarOptions):Array<IntPoint>
	{
		var heuristic = options.heuristic == null ? (i) -> 0 : options.heuristic;
		inline function distance(p1:{ x:Int, y:Int }, p2:{ x:Int, y:Int }):Float return ((p1.x - p2.x).abs().pow(2) + (p1.y - p2.y).abs().pow(2)).sqrt();
		inline function pos_equal(p1:{ x:Int, y:Int }, p2:{ x:Int, y:Int }) return p1.x == p2.x && p1.y == p2.y;
		inline function pos_to_string(p:{ x:Int, y:Int }):String return 'x: ${p.x} | y: ${p.y}';
		inline function check_passable(x:Int, y:Int) return y >= 0 && y < array.length && x >= 0 && x < array[y].length && options.passable.indexOf(array[y][x]) >= 0;
		inline function get_node(pos:{ x:Int, y:Int}, ?parent:AStarNode):AStarNode {
			var out:AStarNode = {
				pos: pos,
				g_cost: distance(pos, options.start),
				h_cost: distance(pos, options.end) + heuristic(array[pos.y][pos.x]),
				f_cost: 0,
				parent: parent,
			};
			out.f_cost = out.g_cost + out.h_cost;
			return out;
		}

		var start_node = get_node(options.start);
		var open:Map<String, AStarNode> = new Map();
		var closed:Map<String, AStarNode> = new Map();
		open.set(pos_to_string(start_node.pos), start_node);

		inline function get_neighbors(node:AStarNode):Array<AStarNode> {
			var out = [];
			if (check_passable(node.pos.x, node.pos.y - 1)) out.push(get_node({ x: node.pos.x, y: node.pos.y - 1 }, node));
			if (check_passable(node.pos.x, node.pos.y + 1)) out.push(get_node({ x: node.pos.x, y: node.pos.y + 1 }, node));
			if (check_passable(node.pos.x - 1, node.pos.y)) out.push(get_node({ x: node.pos.x - 1, y: node.pos.y }, node));
			if (check_passable(node.pos.x + 1, node.pos.y)) out.push(get_node({ x: node.pos.x + 1, y: node.pos.y }, node));
			if (!options.diagonal) return out;
			if (check_passable(node.pos.x - 1, node.pos.y - 1)) out.push(get_node({ x: node.pos.x - 1, y: node.pos.y - 1 }, node));
			if (check_passable(node.pos.x + 1, node.pos.y - 1)) out.push(get_node({ x: node.pos.x + 1, y: node.pos.y - 1 }, node));
			if (check_passable(node.pos.x - 1, node.pos.y + 1)) out.push(get_node({ x: node.pos.x - 1, y: node.pos.y + 1 }, node));
			if (check_passable(node.pos.x + 1, node.pos.y + 1)) out.push(get_node({ x: node.pos.x + 1, y: node.pos.y + 1 }, node));
			return out;
		}

		var i = 0;
		var current:AStarNode = null;
		while (true) {
			var o_nodes = [for (node in open) node];
			if (o_nodes.length == 0) break;
			o_nodes.sort((n1:AStarNode, n2:AStarNode) -> {
				if (n1.f_cost < n2.f_cost) return -1;
				if (n2.f_cost < n1.f_cost) return 1;
				if (n1.h_cost < n2.h_cost) return -1;
				if (n2.h_cost < n1.h_cost) return 1;
				return 0;
			});
			current = o_nodes.shift();
			open.remove(pos_to_string(current.pos));
			closed.set(pos_to_string(current.pos), current);
			if (pos_equal(current.pos, options.end)) break;
			var neighbors = get_neighbors(current);
			for (node in neighbors) {
				var key = pos_to_string(node.pos);
				if (closed.exists(key)) continue;
				if (open.exists(key) && open[key].f_cost < node.f_cost) continue;
				open.set(pos_to_string(node.pos), node);
			}
		}

		var out = [];
		if (!pos_equal(current.pos, options.end)) return [];
		while (current.parent != null) {
			out.unshift (IntPoint.get(current.pos.x, current.pos.y));
			current = current.parent;
		}
		return out;
	}


}

private typedef AStarOptions = {
	start: { x:Int, y:Int },
	end: { x:Int, y:Int },
	passable: Array<Int>,
	diagonal: Bool,
	?heuristic: Int -> Float,
}

private typedef AStarNode = {
	pos: { x:Int, y:Int },
	g_cost:Float,
	h_cost:Float,
	f_cost:Float,
	?parent:AStarNode,
}