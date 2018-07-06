package zero.flxutil.states.sub;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  A SubState that Fades out and closes
 */
class FadeOut extends SubState
{

	/**
	 *  Creates a new substate that fades in and closes
	 *  @param on_complete	function to call when fade is complete (FlxG.switchState() is a good choice :P)
	 *  @param time			the amount of time to fade in
	 *  @param sprite		a sprite to show in place of a solid color
	 *  @param color		a color to show in place of black
	 */
	public function new(on_complete:Void -> Void, time:Float = 0.5, ?sprite:FlxSprite, ?color:Int = 0xff000000)
	{
		super();
		if (sprite == null) 
		{
			sprite = new FlxSprite();
			sprite.makeGraphic(FlxG.width, FlxG.height, color);
		}
		sprite.scrollFactor.set();
		add(sprite);
		sprite.alpha = 0;
		FlxTween.tween(sprite, { alpha:1 }, time).onComplete = function(t:FlxTween){
			on_complete();
			close();
		}
	}

}