package zero.ext.flx;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;

using Math;
using zero.ext.flx.FlxTilemapExt;

class FlxTilemapExt
{

	/**
	 * Returns the tile index at a given point
	 * @param t	tilemap
	 * @param p point
	 * @return Int
	 */
	public static inline function get_index_from_point(t:FlxTilemap, p:FlxPoint):Int return t.getTile(((p.x - t.x) / t.get_tile_width()).floor(), ((p.y - t.y) / t.get_tile_height()).floor());

	/**
	 * Returns a tile's allowCollisions value at a given point
	 * @param t	tilemap
	 * @param p	point
	 * @return Int
	 */
	public static inline function get_collisions_from_point(t:FlxTilemap, p:FlxPoint):Int return t.getTileCollisions(t.get_index_from_point(p));

	/**
	 * Returns the tile width of a tilemap
	 * @param t tilemap
	 * @return return
	 */
	public static inline function get_tile_width(t:FlxTilemap):Float return t.width / t.widthInTiles;

	/**
	 * Returns the tile height of a tilemap
	 * @param t tilemap
	 * @return return
	 */
	public static inline function get_tile_height(t:FlxTilemap):Float return t.height / t.heightInTiles;

}