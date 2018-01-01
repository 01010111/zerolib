package zero.ext.flx;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 *  @author 01010111 
 */
class FlxSpriteExt
{

    inline public static function make_and_center_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
        sprite.offset.set(sprite.width * 0.5 - width * 0.5, sprite.height * 0.5 - height * 0.5);
        sprite.setSize(width, height);
	}

    inline public static function make_anchored_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
        sprite.offset.set(sprite.width * 0.5 - width, sprite.height - height);
        sprite.setSize(width, height);
	}

    inline public static function set_facing_flip_horizontal(sprite:FlxSprite, graphic_facing_right:Bool = true):Void
	{
		sprite.setFacingFlip(FlxObject.LEFT, graphic_facing_right, false);
		sprite.setFacingFlip(FlxObject.RIGHT, !graphic_facing_right, false);
	}

    inline public static function get_anchor(sprite:FlxSprite):FlxPoint
	{
		return FlxPoint.get(sprite.x + sprite.width * 0.5, sprite.y + sprite.height);
	}

    inline public static function set_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x, point.y);
    }

    inline public static function set_anchor_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height);
    }

    inline public static function set_midpoint_position(sprite:FlxSprite, point:FlxPoint)
    {
        sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height * 0.5);
    }

}