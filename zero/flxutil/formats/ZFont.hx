package zero.flxutil.formats;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxText.FlxTextAlign;
import haxe.Json;
import openfl.Assets;
import openfl.display.BitmapData;
import zero.flxutil.ui.BitmapText;

using Math;
using StringTools;

typedef ZFont =
{
	name:String,
	size:ZFontSize,
	chars:Array<ZCharData>,
}

typedef ZFontOptions =
{
	zfont:String,
	?colors:ZFontColors,
	?position:FlxPoint,
	?align:FlxTextAlign,
	?width:Int,
	?letter_spacing:Int,
	?line_spacing:Int,
	?scroll_factor:FlxPoint,
}

typedef ZFontColors =
{
	one:Int,
	zero:Int,
}

typedef ZFontSize =
{
	x:Int,
	y:Int,
}

typedef ZCharData =
{
	char:String,
	data:String,
}

class ZFonts
{
	public static var FONT_SQUARE:String = "FONT_SQUARE";
	public static var FONT_NES:String = "FONT_NES";
}

class ZFontUtil
{

	/**
	 * Creates a new bitmaptext instance from the ZFont schematic
	 * @param options 
	 * @return Null<BitmapText>
	 */
	public static function to_bitmap_text(options:ZFontOptions):Null<BitmapText>
	{
		if (options.zfont.trim().charAt(0) != '{') options.zfont = Assets.getText(options.zfont);
		var zfont:ZFont = Json.parse(options.zfont);
		if (!validate(zfont)) return null;
		if (options.colors == null) options.colors = { zero: 0x00FFFFFF, one: 0xFFFFFFFF };
		return new BitmapText({
			charset: [for (char in zfont.chars) char.char].join(''),
			letter_size: FlxPoint.get(zfont.size.x, zfont.size.y),
			graphic: create_graphic_from_zfont(zfont, options.colors),
			position: options.position,
			align: options.align,
			width: options.width,
			letter_spacing: options.letter_spacing,
			line_spacing: options.line_spacing,
			scroll_factor: options.scroll_factor
		});
	}

	static function validate(font:ZFont):Bool
	{
		for (char in font.chars) if (char.data.length != font.size.x * font.size.y) return false;
		return true;
	}

	static function create_graphic_from_zfont(font:ZFont, colors:ZFontColors):FlxBitmapFontGraphicAsset
	{
		var size = font.chars.length.sqrt().ceil();
		var data = new BitmapData(size * font.size.x, size * font.size.y, true, 0x00FFFFFF);
		var x = 0;
		var y = 0;
		for (char in font.chars)
		{
			for (j in 0...font.size.y) for (i in 0...font.size.x)
				(char.data.charAt(i + j * font.size.x) == '1') 
				? data.setPixel32(x * font.size.x + i, y * font.size.y + j, colors.one)
				: data.setPixel32(x * font.size.x + i, y * font.size.y + j, colors.zero);
			x++;
			if (x < size) continue;
			x = 0;
			y++;
		}
		return data;
	}

}