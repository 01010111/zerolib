package zero.flxutil.ui;

import haxe.Json;
import openfl.Assets;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.FlxG;
import openfl.display.BitmapData;
import haxe.Utf8;

using Math;
using StringTools;

/**
 * A wrapper for FlxBitmapText that makes it easy to use a monospaced bitmap font image
 */
class BitmapText extends FlxBitmapText
{

	var caps_case:CapsCase;
	public var string(get, set):String;
	function get_string():String return text;
	function set_string(s:String):String
	{
		return text = switch (caps_case)
		{
			case UPPERCASE: s.toUpperCase();
			case LOWERCASE: s.toLowerCase();
			case MIXED, NONE: s;
		};
	}

	/**
	 * Creates a new bitmaptext instance
	 * @param options 
	 */
	public function new(options:BitmapTextOptions) 
	{
		var font:FlxBitmapFont = FlxBitmapFont.fromMonospace(options.graphic, options.charset, options.letter_size);
		super(font);
		autoSize = false;
		options.scroll_factor == null ? scrollFactor.set() : scrollFactor.set(options.scroll_factor.x, options.scroll_factor.y);
		options.position == null ? setPosition() : setPosition(options.position.x, options.position.y);
		options.width == null ? set_fieldWidth(Math.round(FlxG.width - x)) : set_fieldWidth(options.width);
		alignment = options.align == null ? FlxTextAlign.LEFT : options.align;
		lineSpacing = options.line_spacing == null ? 0 : options.line_spacing;
		letterSpacing = options.letter_spacing == null ? 0 : options.letter_spacing;
		caps_case = options.charset.indexOf('a') >= 0 ? options.charset.indexOf('A') >= 0 ? MIXED : LOWERCASE : options.charset.indexOf('A') >= 0 ? UPPERCASE : NONE;
	}

	/**
	 * Creates a new bitmaptext instance from a bitsy font file
	 * ~~~WARNING~~~ Utf8 validation is kinda broke so you may want to edit
	 * unused letters out of your file or something, and run plenty of 
	 * tests before shipping!
	 * @param options 
	 * @return BitmapText
	 */
	public static function from_bitsy(options:BitsyOptions):BitmapText
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

	/**
	 * Creates a new bitmaptext instance from the ZFont schematic
	 * @param options 
	 * @return Null<BitmapText>
	 */
	public static function from_zfont(options:ZFontOptions):Null<BitmapText>
	{
		if (options.zfont.trim().charAt(0) != '{') options.zfont = Assets.getText(options.zfont);
		var zfont:ZFont = Json.parse(options.zfont);
		if (!validate_zfont(zfont)) return null;
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

	static function validate_zfont(font:ZFont):Bool
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

class ZFonts
{
	public static var FONT_SQUARE:String = "FONT_SQUARE";
	public static var FONT_NES:String = "FONT_NES";
}

typedef BitmapTextOptions =
{
	charset:String,
	letter_size:FlxPoint,
	graphic:FlxBitmapFontGraphicAsset,
	?position:FlxPoint,
	?align:FlxTextAlign,
	?width:Int,
	?letter_spacing:Int,
	?line_spacing:Int,
	?scroll_factor:FlxPoint,
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

typedef BitsyFont =
{
	font:String,
	size:BitsySize,
	chars:Array<BitsyCharData>,
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

typedef ZFont =
{
	name:String,
	size:BitsySize,
	chars:Array<ZCharData>,
}

typedef ZCharData =
{
	char:String,
	data:String,
}

enum CapsCase
{
	UPPERCASE;
	LOWERCASE;
	MIXED;
	NONE;
}