package zero.flxutil.formats;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

using zero.ext.StringExt;

/**
 *  A Wrapper for FlxOgmoLoader with the ability to return tile data in an Array or CSV
 */
class OgmoLoader extends FlxOgmoLoader
{

	/**
	 * Returns 2D array of tile ids of a given tile layer
	 * @param tile_layer 
	 * @return
	 */
	public function get_tilemap_array(tile_layer:String = 'tiles'):Array<Array<Int>> return _fastXml.node.resolve(tile_layer).innerData.csv_to_2d_int_array();

	/**
	 * Returns CSV of tile ids of a given tile layer
	 * @param tile_layer 
	 * @return
	 */
	public function get_tilemap_csv(tile_layer:String = 'tiles'):String return _fastXml.node.resolve(tile_layer).innerData;

}