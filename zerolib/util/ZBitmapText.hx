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