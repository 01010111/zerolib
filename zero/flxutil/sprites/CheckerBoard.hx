package zero.flxutil.sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

using zero.ext.FloatExt;
using Math;

/**
 *  creates a checkerboard!
 */
class CheckerBoard extends FlxSprite
{

	/**
	 *  Creates a new checkerboard sprite
	 *  @param width		this sprite's width
	 *  @param height		this sprite's height
	 *  @param color0		first color
	 *  @param color1		second color
	 *  @param tile_width	checkerboard tile width
	 *  @param tile_height	checkerboard tile height
	 */
	public function new(width:Int, height:Int, color0:Int, color1:Int, tile_width:Int, tile_height:Int)
	{
		super();

		if (width <= 0) width = FlxG.width;
		if (height <= 0) height = FlxG.height;

		makeGraphic(width, height, 0x00FFFFFF);

		for (y in 0...(height / tile_height).ceil().to_int())
			for (x in 0...(width / tile_width).ceil().to_int())
				FlxSpriteUtil.drawRect(this, x * tile_width, y * tile_height, tile_width, tile_height, ((x + y) % 2 == 0 ? color0 : color1));
	}
	
}