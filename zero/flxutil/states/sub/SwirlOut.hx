package zero.flxutil.states.sub;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

using Math;
using zero.ext.flx.FlxPointExt;

/**
 *  @author 01010111
 */
class SwirlOut extends SubState
{

    public function new(on_complete:Void -> Void, color:Int = 0xff000000)
    {
		super();
		var s:FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		FlxSpriteUtil.fill(s, 0x00ffffff);
		s.scrollFactor.set();
		add(s);
		var t = 0.0;
		var w = 1.25 / FlxG.width;
		for (i in 0...(FlxG.width * 0.8).round())
		{
			new FlxTimer().start(i * w + 0.01).onComplete = function(t:FlxTimer) {
				var p = FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5).place_on_circumference(i * 5, FlxG.width * 0.8 - i);
				FlxSpriteUtil.drawCircle(s, p.x, p.y, 80, color);
			}
			t += w;
		}
		
		new FlxTimer().start(t + 0.01).onComplete = function(t:FlxTimer){
			on_complete();
			close();	
		}
    }

}