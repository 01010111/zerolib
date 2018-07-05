package zero.flxutil.states.sub;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  @author 01010111 
 */
class FadeIn extends SubState
{

	public var on_complete:Void -> Void = function() { };

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