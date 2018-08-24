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

enum CapsCase
{
	UPPERCASE;
	LOWERCASE;
	MIXED;
	NONE;
}