package zero.utilities;

using Math;

/**
 * A Haxe implementation of the line of sight algorithm on [roguebasin]()
 * 
 * **Usage:**
 * ```
 * var map_data = [
 * 	' ########       '.split(''),
 * 	' #......#       '.split(''),
 * 	' #......#       '.split(''),
 * 	' #......####### '.split(''),
 * 	' ####.####....# '.split(''),
 * 	'   #..........# '.split(''),
 * 	'   #...###....# '.split(''),
 * 	'   ##### ###### '.split(''),
 * ];
 * var los = new LineOfSight({ map: map_data, walls: ['#'] });
 * var p = { x: 5, y: 5 };
 * 
 * los.fov(p.x, p.y, 6);
 * for (row in los.place_char(los.get_lit_map('?'), '@', p)) trace(row.join(''));
 * ```
 * Output:
 * ```
 * ???#####????????
 * ????...?????????
 * ????...?????????
 * ????...?????????
 * ??###.####.?????
 *    #.@.....?????
 * ?? #...###.?????
 * ???#####????????
 * ```
 */
class LineOfSight<T>
{

	var map:Array<Array<T>>;
	var walls:Array<T>;
	var lit_map:Array<Array<Int>>;
	var memorized:Array<Array<Int>>;

	public function new(options:{ map:Array<Array<T>>, walls:Array<T> })
	{
		map = options.map;
		walls = options.walls;
		lit_map = [ for (j in 0...map.length) [ for (i in 0...map[j].length) 0 ] ];
		memorized = [ for (j in 0...map.length) [ for (i in 0...map[j].length) 0 ] ];
	}

	public function fov(x:Int, y:Int, radius:Int)
	{
		clear_lit_map();
		for (j in -radius...radius + 1) for (i in -radius...radius + 1)
			if (i * i + j * j < radius * radius)
				los({ x: x, y: y }, { x: x + i, y: y + j });
	}

	public function get_lit_map(unseen:T):Array<Array<T>>
	{
		return [ 
			for (j in 0...map.length) [
				for (i in 0...map[j].length) 
					lit_map[j][i] == 1 ? map[j][i] : unseen
			]
		];
	}

	public function place_char(map:Array<Array<T>>, char:T, p:{ x:Int, y:Int }):Array<Array<T>>
	{
		map[p.y][p.x] = char;
		return map;
	}

	function los(p1:{ x:Int, y:Int }, p2:{ x:Int, y:Int })
	{
		var d = { x: p2.x - p1.x, y: p2.y - p1.y };
		var s = { x: (p1.x < p2.x) ? 1 : -1, y: (p1.y < p2.y) ? 1 : -1 };
		var next = { x: p1.x, y: p1.y };
		var dist:Float = (d.x * d.x + d.y * d.y).sqrt();
		while (next.x != p2.x && next.y != p2.y)
		{
			if (walls.indexOf(map[next.y][next.x]) >= 0) return tag_memorised(next);
			if ((d.y * (next.x - p1.x + s.x) - d.x * (next.y - p1.y)).abs() / dist < 0.5) next.x += s.x;
			else if((d.y * (next.x - p1.x) - d.x * (next.y - p1.y + s.y)).abs() / dist < 0.5) next.y += s.y;
			else next = { x: next.x + s.x, y: next.y + s.y }
		}
		return lit(p2);
	}

	function in_bounds(p:{ x:Int, y:Int }):Bool return p.y >= 0 && p.y < map.length && p.x >= 0 && p.x < map[p.y].length;
	function clear_lit_map() for (row in lit_map) for (i in row) i = 0;
	function tag_memorised(p:{ x:Int, y:Int }) memorized[p.y][p.x] = 1;
	function lit(p:{ x:Int, y:Int }) if (in_bounds(p)) lit_map[p.y][p.x] = 1;
	
}