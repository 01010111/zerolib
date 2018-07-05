package zero.flxutil.states.sub;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  @author 01010111 
 */
class FadeOut extends SubState
{

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