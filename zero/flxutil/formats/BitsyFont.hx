package zero.flxutil.formats;

import openfl.Assets;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxText.FlxTextAlign;
import openfl.display.BitmapData;
import haxe.Utf8;
import zero.flxutil.ui.BitmapText;

using Math;

typedef BitsyFont =
{
	font:String,
	size:BitsySize,
	chars:Array<BitsyCharData>,
}

typedef BitsyOptions =
{
	bitsy_file:String,
	?position:FlxPoint,
	?align:FlxTextAlign,
	?width:Int,
	?letter_spacing:Int,
	?line_spacing:Int,
	?scroll_factor:FlxPoint,
}

typedef BitsySize =
{
	x:Int,
	y:Int,
}

typedef BitsyCharData = 
{
	id:Int,
	char:String,
	data:Array<Array<Int>>,
}

class BitsyFontUtil
{

	/**
	 * Creates a new bitmaptext instance from a bitsy font file
	 * ~~~WARNING~~~ Utf8 validation is kinda broke so you may want to edit
	 * unused letters out of your file or something, and run plenty of 
	 * tests before shipping!
	 * @param options 
	 * @return BitmapText
	 */
	public static function to_bitmap_text(options:BitsyOptions):BitmapText
	{
		var bitsy_font = parse_bitsy_font(openfl.Assets.getText(options.bitsy_file));
		return new BitmapText({
			charset: [for (char in bitsy_font.chars) char.char].join(''),
			letter_size: FlxPoint.get(bitsy_font.size.x + 1, bitsy_font.size.y + 1),
			graphic: create_graphic_from_bitsy_font(bitsy_font),
			position: options.position,
			align: options.align,
			width: options.width,
			letter_spacing: options.letter_spacing,
			line_spacing: options.line_spacing,
			scroll_factor: options.scroll_factor
		});
	}

	static function parse_bitsy_font(input:String):BitsyFont
	{
		var bitsy_font:BitsyFont = { font: '', size: { x:0, y:0 }, chars: [] };
		
		var lines = input.split('\n');
		for (line in lines)
		{
			if		(line.indexOf('FONT') >= 0) bitsy_font.font = line.split(' ')[1];
			else if	(line.indexOf('SIZE') >= 0) bitsy_font.size = { x: Std.parseInt(line.split(' ')[1]), y: Std.parseInt(line.split(' ')[2]) };
			else if	(line.indexOf('CHAR') >= 0) bitsy_font.chars.push({ id: Std.parseInt(line.split(' ')[1]), char: String.fromCharCode(Std.parseInt(line.split(' ')[1])), data: [] });
			else if (line.indexOf('0') >= 0 || line.indexOf('1') >= 0) bitsy_font.chars[bitsy_font.chars.length - 1].data.push([ for (char in line.split('')) Std.parseInt(char) ]);
		}

		for (char in bitsy_font.chars) if (!Utf8.validate(char.char)) bitsy_font.chars.remove(char);
		for (char in bitsy_font.chars) if (!Utf8.validate(char.char)) bitsy_font.chars.remove(char);

		return bitsy_font;
	}

	static function create_graphic_from_bitsy_font(font:BitsyFont):FlxBitmapFontGraphicAsset
	{
		var size = font.chars.length.sqrt().ceil();
		var data:BitmapData = new BitmapData(size * (font.size.x + 1), size * (font.size.y + 1), true, 0x00FFFFFF);
		var x = 0;
		var y = 0;
		for (char in font.chars)
		{
			for (j in 0...char.data.length) for (i in 0...char.data[j].length) if (char.data[j][i] == 1) data.setPixel32(x * (font.size.x + 1) + i, y * (font.size.y + 1) + j, 0xFFFFFFFF);
			x++;
			if (x < size) continue;
			x = 0;
			y++;
		}
		return data;
	}

}