package zero.flxutil.sprites;

import flixel.FlxG;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;
using Math;

class Grid extends FlxSprite
{

	public function new(options:GridOptions)
	{
		super(options.x, options.y);
		makeGraphic(options.width == null ? FlxG.width : options.width, options.height == null ? FlxG.height : options.height, 0x00FFFFFF);
		for (j in 0...(height / options.grid_size).floor()) this.drawLine(0, j * options.grid_size, width, j * options.grid_size, { color: options.color == null ? 0xFF808080 : options.color });
		for (i in 0...(width / options.grid_size).floor()) this.drawLine(i * options.grid_size, 0, i * options.grid_size, height, { color: options.color == null ? 0xFF808080 : options.color });
	}

}

typedef GridOptions =
{
	grid_size:Int,
	?x:Float,
	?y:Float,
	?width:Int,
	?height:Int,
	?color:Int,
}