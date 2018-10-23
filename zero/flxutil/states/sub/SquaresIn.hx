package zero.flxutil.states.sub;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

using Math;

/**
 *  A SubState that Fades in and closes
 */
class SquaresIn extends SubState
{

	/**
	 *  callback function that is called when fade is complete
	 */
	public var on_complete:Void -> Void = function() { };

	/**
	 *  Creates a new substate that fades in and closes
	 *  @param time		the amount of time to fade in
	 *  @param sprite	a sprite to show in place of a solid color
	 *  @param color	a color to show in place of black
	 */
	public function new(time:Float = 0.5, ?size:Int = 16, ?color:Int = 0xff000000)
	{
		super();
		var t = 0.0;
		for (j in 0...(FlxG.height / size).ceil()) for (i in 0...(FlxG.width / size).ceil())
		{
			var s = new FlxSprite(i * size, j * size);
			s.makeGraphic(size, size, color);
			s.scrollFactor.set();
			add(s);

			var time = (i + j) * 0.025;
			new FlxTimer().start(time).onComplete = (_) -> {
				FlxTween.tween(s.scale, { x: 0, y: 0 }, 0.1);
			}
			t = t.max(time + 0.1);
		}
		new FlxTimer().start(t).onComplete = (_) -> close();
	}

}