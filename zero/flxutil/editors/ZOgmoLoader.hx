package zero.flxutil.editors;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

using zero.ext.StringExt;

/**
 *  @author 01010111 
 */
class ZOgmoLoader extends FlxOgmoLoader
{

    public function get_tilemap_array(tile_layer:String = 'tiles'):Array<Array<Int>>
    {
        return _fastXml.node.resolve(tile_layer).innerData.csv_to_2d_int_array();
    }

}