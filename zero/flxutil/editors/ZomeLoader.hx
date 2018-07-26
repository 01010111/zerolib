package zero.flxutil.editors;

import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.system.FlxAssets;
import haxe.Json;

/**
 * A class for loading json levels created with ZOME (01010111/itch.io/zome)
 */
class ZomeLoader
{

	var level:ZomeLevel;
	var tileset_folder:String;

	/**
	 * Initializes the loader with a json file
	 * @param json_path			the path to the json file created by ZOME
	 * @param tileset_folder	the path that contains the tileset for the level
	 */
	public function new(json_path:String, tileset_folder:String = 'assets/images/')
	{
		this.level = Json.parse(openfl.Assets.getText(json_path));
		this.tileset_folder = tileset_folder;
	}

	/**
	 * returns a 2D array of level tiles
	 * @return Array<Array<Int>>
	 */
	public function get_level_array():Array<Array<Int>> return level.data;

	/**
	 * Returns the filename of the tileset used
	 * @return String
	 */
	public function get_tileset():String return level.tileset;

	/**
	 * Returns a FlxTilemap of the level
	 * @param options
	 * @return FlxTilemap
	 */
	public function get_tilemap(?options:TilemapOptions):FlxTilemap
	{
		var tilemap = new FlxTilemap();
		load_tilemap(tilemap, options);
		return tilemap;
	}

	/**
	 * Returns a FlxTilemapExt of the level
	 * @param options 
	 * @return FlxTilemapExt
	 */
	public function get_tilemap_ext(?options:TilemapExtOptions):FlxTilemapExt
	{
		var tilemap = new FlxTilemapExt();
		load_tilemap(tilemap, options.tilemap_options);
		tilemap.setSlopes(options.northwest_slopes, options.northeast_slopes, options.southwest_slopes, options.southeast_slopes);
		return tilemap;
	}

	function load_tilemap(tilemap:FlxTilemap, options:TilemapOptions)
	{
		options = prep_tilemap_options(options);
		tilemap.loadMapFrom2DArray(
			level.data,
			options.tile_graphic,
			options.tile_width,
			options.tile_height,
			options.auto_tile,
			options.starting_index,
			options.draw_index,
			options.collide_index
		);
		if (options.collision_array != null) set_tile_properties(tilemap, options.collision_array);
		if (options.follow) tilemap.follow();
	}

	function prep_tilemap_options(options:TilemapOptions):TilemapOptions
	{
		if (options == null) options = {};
		if (options.tile_graphic == null) options.tile_graphic = '$tileset_folder${level.tileset}';
		if (options.tile_width == null) options.tile_width = 16;
		if (options.tile_height == null) options.tile_height = 16;
		if (options.starting_index == null) options.starting_index = 0;
		if (options.draw_index == null) options.draw_index = 0;
		if (options.collide_index == null) options.collide_index = 1;
		if (options.follow == null) options.follow = true;
		return options;
	}

	function set_tile_properties(tilemap:FlxTilemap, collision_array:Array<Int>)
	{
		for (i in 0...collision_array.length) tilemap.setTileProperties(i, collision_array[i]);
	}

}

typedef ZomeLevel =
{
	data:Array<Array<Int>>,
	tileset:String
}

typedef TilemapOptions =
{
	?tile_width:Int,
	?tile_height:Int,
	?tile_graphic:FlxTilemapGraphicAsset,
	?auto_tile:FlxTilemapAutoTiling,
	?starting_index:Int,
	?draw_index:Int,
	?collide_index:Int,
	?collision_array:Array<Int>,
	?follow:Bool
}

typedef TilemapExtOptions =
{
	?tilemap_options:TilemapOptions,
	?northeast_slopes:Array<Int>,
	?northwest_slopes:Array<Int>,
	?southeast_slopes:Array<Int>,
	?southwest_slopes:Array<Int>
}