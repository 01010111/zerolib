package zero.ext.flx;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import zero.util.IntPoint;
import zero.util.Vector;

using Math;
using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;
using zero.ext.flx.FlxTilemapExt;

class FlxTilemapExt
{

	public static inline function get_index_from_point(t:FlxTilemap, p:FlxPoint):Int return t.getTile((p.x / t.get_tile_width()).floor(), (p.y / t.get_tile_height()).floor());
	public static inline function get_collisions_from_point(t:FlxTilemap, p:FlxPoint):Int return t.getTileCollisions(t.get_index_from_point(p));
	public static inline function get_tile_width(t:FlxTilemap) return t.width / t.widthInTiles;
	public static inline function get_tile_height(t:FlxTilemap) return t.height / t.heightInTiles;

}