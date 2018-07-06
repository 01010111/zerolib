package zero.flxutil.ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.FlxG;

/**
 * A wrapper for FlxBitmapText that makes it easy to use a monospaced bitmap font image
 */
class ZBitmapText extends FlxBitmapText
{
	/**
	 * Creates a new bitmaptext instance with lots of options
	 * @param	X				X Position of your text
	 * @param	Y				Y Position of your text
	 * @param	LETTERS			String	String of letters included in your graphic
	 * @param	LETTERSIZE		FlxPoint	Width and Height of glyph in your graphic
	 * @param	FONTGRAPHIC		font graphic
	 * @param	ALIGN			Defaults to left
	 * @param	WIDTH			Set width of your text area
	 * @param	LINESPACING		Space between lines
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