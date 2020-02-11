package zero.utilities;

using haxe.Json;
using zero.utilities.OgmoUtils;

/**
 * A group of Utility functions for working with OGMO files (level .json and project .ogmo files) in haxe
 */
class OgmoUtils
{

	// region PARSING
	/**
	 * Parse OGMO Editor level .json text
	 * @param json 
	 * @return LevelData
	 */
	public static function parse_level_json(json:String):LevelData
	{
		return cast json.parse();
	}

	/**
	 * Parse OGMO Editor Project .ogmo text
	 * @param json 
	 * @return ProjectData
	 */
	public static function parse_project_json(json:String):ProjectData
	{
		return cast json.parse();
	} // endregion

	// region LAYERS
	/**
	 * Get Tile Layer data matching a given name
	 * @param data 
	 * @param name 
	 * @return TileLayer
	 */
	public static function get_tile_layer(data:LevelData, name:String):TileLayer
	{
		for (layer in data.layers) if (layer.name == name) return cast layer;
		return null;
	}
	
	/**
	 * Get Grid Layer data matching a given name
	 * @param data 
	 * @param name 
	 * @return TileLayer
	 */
	public static function get_grid_layer(data:LevelData, name:String):GridLayer
	{
		for (layer in data.layers) if (layer.name == name) return cast layer;
		return null;
	}
	
	/**
	 * Get Entity Layer data matching a given name
	 * @param data 
	 * @param name 
	 * @return EntityLayer
	 */
	public static function get_entity_layer(data:LevelData, name:String):EntityLayer
	{
		for (layer in data.layers) if (layer.name == name) return cast layer;
		return null;
	}

	/**
	 * Get Decal Layer data matching a given name
	 * @param data 
	 * @param name 
	 * @return DecalLayer
	 */
	public static function get_decal_layer(data:LevelData, name:String):DecalLayer
	{
		for (layer in data.layers) if (layer.name == name) return cast layer;
		return null;
	} // endregion

	// region DATA
	/**
	 * Get matching Layer data from a given name
	 * @param data 
	 * @param name 
	 * @return ProjectLayerData
	 */
	public static function get_layer_data(data:ProjectData, name:String):ProjectLayerData
	{
		for (layer in data.layers) if (layer.name == name) return layer;
		return null;
	}

	/**
	 * Get matching Tileset data from a given name
	 * @param data 
	 * @param name 
	 * @return ProjectTilesetData
	 */
	public static function get_tileset_data(data:ProjectData, name:String):ProjectTilesetData
	{
		for (tileset in data.tilesets) if (tileset.label == name) return tileset;
		return null;
	}

	/**
	 * Get matching Entity data from a given name
	 * @param data 
	 * @param name 
	 * @return ProjectEntityData
	 */
	public static function get_entity_data(data:ProjectData, name:String):ProjectEntityData
	{
		for (entity in data.entities) if (entity.name == name) return entity;
		return null;
	} // endregion

	// region LOADERS
	/**
	 * Perform a function using all entities in a given layer
	 * @param layer 
	 * @param fn 
	 */
	public static function load_entities(layer:EntityLayer, fn:EntityData -> Void)
	{
		for (entity in layer.entities) fn(entity);
	}

	/**
	 * Perform a function using all decals in a given layer
	 * @param layer 
	 * @param fn 
	 */
	public static function load_decals(layer:DecalLayer, fn:DecalData -> Void)
	{
		for (decal in layer.decals) fn(decal);
	} // endregion

}

// region TYPEDEFS

// Parsed .OGMO Project data
@:dox(hide)
typedef ProjectData = {
	name:String,
	levelPaths:Array<String>,
	backgroundColor:String,
	gridColor:String,
	anglesRadians:Bool,
	directoryDepth:Int,
	levelDefaultSize:{ x:Int, y:Int },
	levelMinSize:{ x:Int, y:Int },
	levelMaxSize:{ x:Int, y:Int },
	levelVaues:Array<Dynamic>,
	defaultExportMode:String,
	entityTags:Array<String>,
	layers:Array<ProjectLayerData>,
	entities:Array<ProjectEntityData>,
	tilesets:Array<ProjectTilesetData>,
}

// Project Layer
@:dox(hide)
typedef ProjectLayerData = {
	definition:String,
	name:String,
	gridSize:{ x:Int, y:Int },
	exportID:String,
	?requiredTags:Array<String>,
	?excludedTags:Array<String>,
	?exportMode:Int,
	?arrayMode:Int,
	?defaultTileset:String,
	?folder:String,
	?includeImageSequence:Bool,
	?scaleable:Bool,
	?rotatable:Bool,
	?values:Array<Dynamic>,
	?legend:Dynamic,
}

// Project Entity
@:dox(hide)
typedef ProjectEntityData = {
	exportID:String,
	name:String,
	limit:Int,
	size:{ x:Int, y:Int },
	origin:{ x:Int, y:Int },
	originAnchored:Bool,
	shape:{ label:String, points:Array<{ x:Int, y:Int }> },
	color:String,
	tileX:Bool,
	tileY:Bool,
	tileSize:{ x:Int, y:Int },
	resizeableX:Bool,
	resizeableY:Bool,
	rotatable:Bool,
	rotationDegrees:Int,
	canFlipX:Bool,
	canFlipY:Bool,
	canSetColor:Bool,
	hasNodes:Bool,
	nodeLimit:Int,
	nodeDisplay:Int,
	nodeGhost:Bool,
	tags:Array<String>,
	values:Array<Dynamic>,
}

// Project Tileset
@:dox(hide)
typedef ProjectTilesetData = {
	label:String,
	path:String,
	image:String,
	tileWidth:Int,
	tileHeight:Int,
	tileSeparationX:Int,
	tileSeparationY:Int,
}

// Parsed .JSON Level data
@:dox(hide)
typedef LevelData = {
	width:Int,
	height:Int,
	offsetX:Int,
	offsetY:Int,
	layers:Array<LayerData>,
	?values:Dynamic,
}

// Level Layer data
@:dox(hide)
typedef LayerData = {
	name:String,
	_eid:String,
	offsetX:Int,
	offsetY:Int,
	gridCellWidth:Int,
	gridCellHeight:Int,
	gridCellsX:Int,
	gridCellsY:Int,
	?entities:Array<EntityData>,
	?decals:Array<DecalData>,
	?tileset:String,
	?data:Array<Int>,
	?data2D:Array<Array<Int>>,
	?dataCSV:String,
	?exportMode:Int,
	?arrayMode:Int,
}

// Tile subset of LayerData
@:dox(hide)
typedef TileLayer = {
	name:String,
	_eid:String,
	offsetX:Int,
	offsetY:Int,
	gridCellWidth:Int,
	gridCellHeight:Int,
	gridCellsX:Int,
	gridCellsY:Int,
	tileset:String,
	exportMode:Int,
	arrayMode:Int,
	?data:Array<Int>,
	?data2D:Array<Array<Int>>,
	?dataCSV:String,
}

// Grid subset of LayerData
@:dox(hide)
typedef GridLayer = {
	name:String,
	_eid:String,
	offsetX:Int,
	offsetY:Int,
	gridCellWidth:Int,
	gridCellHeight:Int,
	gridCellsX:Int,
	gridCellsY:Int,
	arrayMode:Int,
	?grid:Array<String>,
	?grid2D:Array<Array<String>>,
}

// Entity subset of LayerData
@:dox(hide)
typedef EntityLayer = {
	name:String,
	_eid:String,
	offsetX:Int,
	offsetY:Int,
	gridCellWidth:Int,
	gridCellHeight:Int,
	gridCellsX:Int,
	gridCellsY:Int,
	entities:Array<EntityData>,
}

// Individual Entity data
@:dox(hide)
typedef EntityData = {
	name:String,
	id:Int,
	_eid:String,
	x:Int,
	y:Int,
	?width:Int,
	?height:Int,
	?originX:Int,
	?originY:Int,
	?rotation:Float,
	?flippedX:Bool,
	?flippedY:Bool,
	?nodes:Array<{x:Float, y:Float}>,
	?values:Dynamic,
}

// Decal subset of LayerData
@:dox(hide)
typedef DecalLayer = {
	name:String,
	_eid:String,
	offsetX:Int,
	offsetY:Int,
	gridCellWidth:Int,
	gridCellHeight:Int,
	gridCellsX:Int,
	gridCellsY:Int,
	decals:Array<DecalData>,
}

// Individual Decal data
@:dox(hide)
typedef DecalData = {
	x:Int,
	y:Int,
	texture:String,
	?scaleX:Float,
	?scaleY:Float,
	?rotation:Float,
}

// endregion
