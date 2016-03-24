package zerolib;
import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * Only works on flash targets! Also kinda sucks :P
 * @author 01010111
 */
class ZMosaic extends FlxSprite
{
	
	public var callback:Void -> Void = function() {  };
	
	public function new(iterations:Int = 4, time_between_iterations:Float = 0.1) 
	{
		super(0, 0, FlxG.camera.buffer);
		dirty = true;
		scrollFactor.set();
		
		for (i in 0...iterations)
		{
			new FlxTimer().start(i * time_between_iterations).onComplete = function(t:FlxTimer):Void
			{
				mosaic(i + 2);
				//mosaic(Std.int(Math.pow(2, i + 1)));
			}
		}
		
		new FlxTimer().start(iterations * time_between_iterations).onComplete = function(t:FlxTimer):Void{ callback(); }
	}
	
	var switcher:Bool = false;
	
	function mosaic(size:Int):Void
	{
		var _b = new BitmapData(FlxG.width, FlxG.height);
		
		for (s_y in 0...Math.ceil(FlxG.height / size))
		{
			for (s_X in 0...Math.ceil(FlxG.width / size))
			{
				
				for (c_y in 0...size)
				{
					for (c_x in 0...size)
					{
						///* AVERAGE - messes up alpha - */var _color = FlxColor.interpolate(FlxColor.interpolate(pixels.getPixel32(s_X * size, s_y * size), pixels.getPixel32(s_X * size + Std.int(size / 2), s_y * size)), FlxColor.interpolate(pixels.getPixel32(s_X * size, s_y * size + Std.int(size / 2)), pixels.getPixel32(s_X * size + Std.int(size / 2), s_y * size + Std.int(size / 2)))); 
						/* top left - makes it look like it's moving down/right - */
						var _o = !switcher ? 0 : Std.int(size / 2);
						var _color = pixels.getPixel32(s_X * size + _o, s_y * size + _o);
						///* ?? */var _color = pixels.getPixel32(s_X * size + Math.ceil(size / 2), s_y * size + Math.ceil(size / 2));
						
						if (width >= s_X * size + c_x && height >= s_y * size + c_y) 
						{
							_b.setPixel32(s_X * size + c_x, s_y * size + c_y, _color);
						}
					}
				}
			}
				switcher = !switcher;
		}
		
		dirty = true;
		pixels = _b;
	}
	
}