package zero.utilities;

import zero.utilities.IntPoint;

using Math;

/**
 * A* Pathfinding algorithm with methods to simplify the output.
 * 
 * **Usage**
 * 
 * - Get a set of path nodes to traverse a 2D Int Array
 * 
 * ```haxe
 * 	AStar.get_path(my_2D_array, {
 * 		start: [1, 1],
 * 		end: [10, 10],
 * 		passable: [0, 1, 2],
 * 	});
 * ```
 */
class AStar {

	public static function get_path(map:Array<Array<Int>>, options:AStarOptions):Array<IntPoint> {

		// Set defaults
		if (options.mode == null) options.mode = CARDINAL_ONLY;
		if (options.simplify == null) options.simplify = REMOVE_NODES_ON_PATH;
		if (options.heuristic == null) options.heuristic = (i) -> 0;
		
		// Check to see if Simplify Mode conflicts with Mode
		if (options.mode == DIAGONAL && options.simplify == LINE_OF_SIGHT_NO_DIAGONAL) options.mode = CARDINAL_ONLY;

		// Create start and end nodes
		var start_node = get_node(options.start);
		var end_node = get_node(options.end);

		// Initialize lists
		var open:Array<Node> = [start_node];
		var closed:Array<Node> = [];

		// Loop until end is found
		while (open.length > 0) {
			// Find current node, remove from open, add to closed
			open.sort(sort_nodes);
			var current_node = open.shift();
			closed.push(current_node);

			// Check if goal
			if (current_node.position.equals(options.end)) {
				var path = [];
				var current = current_node;
				while (current != null) {
					path.unshift(current.position);
					current = current.parent;
				}
				for (node in open) destroy_node(node);
				path = simplify(path, map, options.simplify, options.passable);
				return path;
			}

			// Generate children
			var children:Array<Node> = [];
			var new_positions:Array<IntPoint> = switch options.mode {
				case CARDINAL_ONLY: [[0, -1], [0, 1], [-1, 0], [1, 0]];
				case DIAGONAL: [[0, -1], [0, 1], [-1, 0], [1, 0], [-1, -1], [1, -1], [-1, 1], [1, 1]];
			}
			for (p in new_positions) {
				var node_pos = current_node.position + p;
				if (validate_position(node_pos, map, options.passable)) children.push({
					position: node_pos,
					parent: current_node,
					f: 0, h: 0, g: 0
				});
			}

			// Loop through children
			for (node in children) {

				// Check if child exists in closed list
				if (in_closed(closed, node)) continue;

				// Generate costs
				node.g = current_node.g + 1;
				node.h = node.position.distance(end_node.position) + options.heuristic(map[node.position.y][node.position.x]);
				node.f = node.g + node.h;

				// Check if child exists in open list
				if (in_open(open, node)) continue;

				open.push(node);
			}
		}

		// Recycle points and return empty list - end is not reachable
		for (node in open) destroy_node(node);
		for (node in closed) destroy_node(node);
		return [];
	}

	/**
		Print out a visual of where the path nodes lie on a map
	**/
	public static function print(map:Array<Array<Int>>, path:Array<IntPoint>, passable:Array<Int>) {
		var node_markers = '①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ';
		var arr = [for (row in map) [for (i in row) passable.indexOf(i) >= 0 ? ' ' : '⬛' ]];
		for (i in 0...path.length) arr[path[i].y][path[i].x] = node_markers.charAt(i % node_markers.length);
		for (row in arr) trace(row.join('.'));
	}

	static function destroy_node(node:Node) {
		node.position.put();
		node = null;
	}

	static function in_closed(closed:Array<Node>, node:Node):Bool {
		for (closed_node in closed) if (node.position.equals(closed_node.position)) return true;
		return false;
	}

	static function in_open(open:Array<Node>, node:Node):Bool {
		for (open_node in open) if (node.position.equals(open_node.position)) {
			if (node.g < open_node.g) open_node.g = node.g;
			return true;
		}
		return false;
	}

	static function validate_position(p:IntPoint, map:Array<Array<Int>>, passable:Array<Int>):Bool {
		return p.y > 0 && p.x > 0 && p.y < map.length && p.x < map[p.y].length && passable.indexOf(map[p.y][p.x]) >= 0;
	}

	static function sort_nodes(n1:Node, n2:Node):Int {
		return n1.f < n2.f ? -1 : n1.f > n2.f ? 1 : 0;
	}

	static function get_node(position:IntPoint, ?parent:Node):Node {
		return {
			position: position,
			parent: parent,
			g: 0,
			h: 0,
			f: 0
		}
	}

	static function simplify(points:Array<IntPoint>, map:Array<Array<Int>>, mode:EAStarSimplifyMode, passable:Array<Int>):Array<IntPoint> {
		return switch mode {
			case NONE: points;
			case REMOVE_NODES_ON_PATH: remove_nodes_on_path(points, map);
			case LINE_OF_SIGHT: los_simplify(points, map, passable);
			case LINE_OF_SIGHT_NO_DIAGONAL: los_nd_simplify(points, map, passable);
		}
	}

	static function remove_nodes_on_path(points:Array<IntPoint>, map:Array<Array<Int>>):Array<IntPoint> {
		if (points.length <= 1) return points;
		var last = points.shift();
		var next = points.shift();
		var v = next - last;
		var out = [last];
		while (points.length > 0) {
			last = next;
			next = points.shift();
			var v2 = next - last;
			if (!v.equals(v2)) out.push(last.copy());
			last.put();
			v = v2;
		}
		out.push(next);
		return out;
	}

	static function los_simplify(points:Array<IntPoint>, map:Array<Array<Int>>, passable:Array<Int>):Array<IntPoint> {
		var last = points.shift();
		var current = points.shift();
		var next = points.shift();
		var out = [last];
		while (points.length > 0) {
			if (los(last, next, map, passable)) {
				var t = current;
				current = next;
				next = points.shift();
				t.put();
			}
			else {
				var t = last;
				out.push(current);
				last = current;
				t.put();
			}
		}
		out.push(next);
		return out;
	}
	
	/**
		Check line of sight, note that the passable array here may be different than the passable array for `get_path()` in case you want objects that you can see through but not walk through (i.e. glass, tables, etc)!
	**/
	public static function los(p1:IntPoint, p2:IntPoint, map:Array<Array<Int>>, passable:Array<Int>):Bool {
		var d = p2 - p1;
		var s:IntPoint = [ (p1.x < p2.x) ? 1 : -1, (p1.y < p2.y) ? 1 : -1 ];
		var next = p1 + 0;
		var dist:Float = d.length;
		while (next.x != p2.x || next.y != p2.y)
		{
			if (passable.indexOf(map[next.y][next.x]) == -1) {
				d.put();
				s.put();
				next.put();
				return false;
			}
			if ((d.y * (next.x - p1.x + s.x) - d.x * (next.y - p1.y)).abs() / dist < 0.5) next.x += s.x;
			else if((d.y * (next.x - p1.x) - d.x * (next.y - p1.y + s.y)).abs() / dist < 0.5) next.y += s.y;
			else next = next + s;
		}
		d.put();
		s.put();
		next.put();
		return true;
	}

	static function los_nd_simplify(points:Array<IntPoint>, map:Array<Array<Int>>, passable:Array<Int>):Array<IntPoint> {
		var last = points.shift();
		var current = points.shift();
		var next = points.shift();
		var out = [last.copy()];
		while (points.length > 0) {
			if (los_no_diagonal(last.copy(), next, map, passable)) {
				current.copy_from(next);
				next = points.shift();
			}
			else {
				out.push(current.copy());
				last.copy_from(current);
			}
		}
		out.push(next.copy());
		return out;
	}

	static function los_no_diagonal(p1:IntPoint, p2:IntPoint, map:Array<Array<Int>>, passable:Array<Int>):Bool {
		var dx = (p2.x - p1.x).abs().floor();
		var dy = (p2.y - p1.y).abs().floor();
		var sx = p1.x < p2.x ? 1 : -1;
		var sy = p1.y < p2.y ? 1 : -1;
		var err = dx - dy;
		var e2:Int;

		while (!p1.equals(p2)) {
			if (passable.indexOf(map[p1.y][p1.x]) == -1) {
				p1.put();
				return false;
			}

			e2 = err * 2;

			if (dy > dx) {
				if (e2 > -dy) {
					err -= dy;
					p1.x += sx;
				}
				else if (e2 < dx) {
					err += dx;
					p1.y += sy;
				}
			}
			else {
				if (e2 < dx) {
					err += dx;
					p1.y += sy;
				}
				else if (e2 > -dy) {
					err -= dy;
					p1.x += sx;
				}
			}
		}
		p1.put();
		return true;
	}

}


typedef AStarOptions = {
	start:IntPoint,
	end:IntPoint,
	passable:Array<Int>,
	?mode:EAStarMode,
	?heuristic:Int -> Int,
	?simplify:EAStarSimplifyMode,
}

enum EAStarMode {
	CARDINAL_ONLY;
	DIAGONAL;
}

enum EAStarSimplifyMode {
	NONE;
	REMOVE_NODES_ON_PATH;
	LINE_OF_SIGHT;
	LINE_OF_SIGHT_NO_DIAGONAL;
}

typedef Node = {
	position:IntPoint,
	g:Float,
	h:Float,
	f:Float,
	?parent:Node,
}