package zerolib;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.display.BitmapData;

/**
 * ...
 * @author waynetron
 * @author 01010111
 */
class ZSprite extends FlxSprite
{
	private var baseBitmap:BitmapData;
	private var whiteBitmap:BitmapData;
	var flash_color:FlxColor;
	
    public function new(_flash_color:FlxColor = FlxColor.WHITE)
    {
    	super();
	}
​
	override public function graphicLoaded()
	{
		whiteBitmap = graphic.bitmap.clone();
		fillWithColour(whiteBitmap, flash_color);
		baseBitmap = graphic.bitmap;
	}
​
	private function fillWithColour(bitmapData:BitmapData, colour:UInt)
	{
		for (row in 0 ... bitmapData.height) {
			for (col in 0 ... bitmapData.width) {
				bitmapData.setPixel(col, row, colour);
			}
		}
	}
​
	public function flash(duration:Float = 0.1)
	{		
		graphic.bitmap = whiteBitmap;
		var oldAlpha:Float = alpha;
		alpha = 1;
		
		new FlxTimer().start(duration, function(timer:FlxTimer) {			
			graphic.bitmap = baseBitmap;
			alpha = oldAlpha;
		}, 1);		
	}
	
	function make_and_center_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height * 0.5 - _height * 0.5);
		setSize(_width, _height);
		offset_ref = offset;
	}
	
	function make_anchored_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height - _height);
		setSize(_width, _height);
		offset_ref = offset;
	}
	
	function set_facing_flip_horizontal(_sprite_facing_right:Bool = true):Void
	{
		setFacingFlip(FlxObject.LEFT, _sprite_facing_right, false);
		setFacingFlip(FlxObject.RIGHT, !_sprite_facing_right, false);
	}
	
	function get_anchor():FlxPoint
	{
		return FlxPoint.get(x + width * 0.5, y + height);
	}
	
	public var pause_timer:Int = 0;
	
	override public function update(elapsed:Float):Void 
	{
		if (pause_timer == 0)
		{
			super.update(elapsed);
		}
		else pause_timer--;
		
		if (jiggle)
		{
			offset.set(offset_ref.x + ZMath.randomRange( -1, 1), offset_ref.y);
		}
	}	
	
}