package zerolib.util;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.FlxG;

/**
 * ...
 * @author x01010111
 */
class ZBitmapText extends FlxBitmapText
{
	/**
	 * A helper class to get bitmapfonts working quickly!
	 * @param	X	Float	X Position of your text
	 * @param	Y	Float	Y Position of your text
	 * @param	LETTERS	String	String of letters included in your graphic
	 * @param	LETTERSIZE	FlxPoint	Width and Height of glyph in your graphic
	 * @param	FONTGRAPHIC	FlxBitmapFontGraphicAsset	font graphic
	 * @param	ALIGN	FlxTextAlign	Defaults to left
	 * @param	WIDTH	Set width of your text area
	 * @param	LINESPACING	Space between lines
	 * @param	LETTERSPACING	Space between letters
	 */
	public function new(X:Float, Y:Float, LETTERS:String, LETTERSIZE:FlxPoint, FONTGRAPHIC:FlxBitmapFontGraphicAsset, ?ALIGN:FlxTextAlign, WIDTH:Int = -1, LINESPACING:Int = 0, LETTERSPACING:Int = 0) 
	{
		var font:FlxBitmapFont = FlxBitmapFont.fromMonospace(FONTGRAPHIC, LETTERS, LETTERSIZE);
		super(font);
		autoSize = false;
		WIDTH == -1? set_fieldWidth(Math.round(FlxG.width - X)): set_fieldWidth(WIDTH);
		ALIGN != null? alignment = ALIGN: alignment = FlxTextAlign.LEFT;
		lineSpacing = LINESPACING;
		letterSpacing = LETTERSPACING;
		setPosition(X, Y);
		scrollFactor.set();
	}
	
}