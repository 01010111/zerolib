package zero.ext.flx;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 *  @author 01010111 
 */
class FlxSpriteExt
{

    /**
     *  Creates a hitbox and centers it on a FlxSprite's frame
     *  @param sprite - 
     *  @param width - 
     *  @param height - 
     */
    inline public static function make_and_center_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
        sprite.offset.set(sprite.width * 0.5 - width * 0.5, sprite.height * 0.5 - height * 0.5);
        sprite.setSize(width, height);
	}

    /**
     *  Creates a hitbox and aligns it to the bottom center point of a FlxSprite's frame
     *  @param sprite - 
     *  @param width - 
     *  @param height - 
     */
    inline public static function make_anchored_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
        sprite.offset.set(sprite.width * 0.5 - width * 0.5, sprite.height - height);
        sprite.setSize(width, height);
	}

    /**
     *  Sets both right and left facing flip
     *  @param sprite - 
     *  @param graphic_facing_right - Whether or not the sprite's graphic is facing right
     */
    inline public static function set_facing_flip_horizontal(sprite:FlxSprite, graphic_facing_right:Bool = true):Void
	{
		sprite.setFacingFlip(FlxObject.LEFT, graphic_facing_right, false);
		sprite.setFacingFlip(FlxObject.RIGHT, !graphic_facing_right, false);
	}

    /**
     *  Returns a bottom center point of a FlxSprite
     *  @param sprite - 
     *  @return FlxPoint
     */
    inline public static function get_anchor(sprite:FlxSprite):FlxPoint
	{
		return FlxPoint.get(sprite.x + sprite.width * 0.5, sprite.y + sprite.height);
	}

    /**
     *  Sets the position of a FlxSprite using a FlxPoint
     *  @param sprite - 
     *  @param point - 
     */
    inline public static function set_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x, point.y);
    }

    /**
     *  Sets the anchor (bottom center) position of a FlxSprite using a FlxPoint
     *  @param sprite - 
     *  @param point - 
     */
    inline public static function set_anchor_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height);
    }

    /**
     *  Sets the midpoint position of a FlxSprite using a FlxPoint
     *  @param sprite - 
     *  @param point - 
     */
    inline public static function set_midpoint_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height * 0.5);
    }

	inline public static function add_animation(sprite:FlxSprite, animation:SpriteAnimation)
	{
		if (animation.looped == null) animation.looped = true;
		sprite.animation.add(animation.name, animation.frames, animation.rate, animation.looped);
	}

}

typedef SpriteAnimation = {
	name:String,
	frames: Array<Int>,
	rate: Int,
	?looped: Bool
}