package zero.flxutil.states.sub;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  A SubState that Fades in and closes
 */
class FadeIn extends SubState
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
	public function new(time:Float = 0.5, ?sprite:FlxSprite, ?color:Int = 0xff000000)
	{
		super();
		if (sprite == null) 
		{
			sprite = new FlxSprite();
			sprite.makeGraphic(FlxG.width, FlxG.height, color);
		}
		sprite.scrollFactor.set();
		add(sprite);
		FlxTween.tween(sprite, { alpha:0 }, time).onComplete = function(t:FlxTween){
			on_complete();
			close();
		}
	}

}