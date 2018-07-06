package zero.ext.flx;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

using openfl.Assets;
using haxe.Json;
using zero.ext.FloatExt;

/**
 *  A collection of extension methods for flixel.FlxSprite
 */
class FlxSpriteExt
{

	/**
	 *  Creates a hitbox and centers it on a FlxSprite's frame
	 *  @param sprite	input sprite
	 *  @param width	hitbox width
	 *  @param height	hitbox height
	 */
	public static inline function make_and_center_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
		sprite.offset.set(sprite.width * 0.5 - width * 0.5, sprite.height * 0.5 - height * 0.5);
		sprite.setSize(width, height);
	}

	/**
	 *  Creates a hitbox and aligns it to the bottom center point of a FlxSprite's frame
	 *  @param sprite	input sprite
	 *  @param width	hitbox width
	 *  @param height	hitbox height
	 */
	public static inline function make_anchored_hitbox(sprite:FlxSprite, width:Float, height:Float):Void
	{
		sprite.offset.set(sprite.width * 0.5 - width * 0.5, sprite.height - height);
		sprite.setSize(width, height);
	}

	/**
	 *  Sets both right and left facing flip
	 *  @param sprite				input sprite
	 *  @param graphic_facing_right	Whether or not the sprite's graphic is facing right
	 */
	public static inline function set_facing_flip_horizontal(sprite:FlxSprite, graphic_facing_right:Bool = true):Void
	{
		sprite.setFacingFlip(FlxObject.LEFT, graphic_facing_right, false);
		sprite.setFacingFlip(FlxObject.RIGHT, !graphic_facing_right, false);
	}

	/**
	 *  Returns a bottom center point of a FlxSprite
	 *  @param sprite	input sprite
	 *  @return			FlxPoint
	 */
	public static inline function get_anchor(sprite:FlxSprite):FlxPoint return FlxPoint.get(sprite.x + sprite.width * 0.5, sprite.y + sprite.height);

	/**
	 *  Sets the position of a FlxSprite using a FlxPoint
	 *  @param sprite	input sprite
	 *  @param point	position
	 */
	public static inline function set_position(sprite:FlxSprite, point:FlxPoint) sprite.setPosition(point.x, point.y);

	/**
	 *  Sets the anchor (bottom center) position of a FlxSprite using a FlxPoint
	 *  @param sprite	input sprite
	 *  @param point	anchor position
	 */
	public static inline function set_anchor_position(sprite:FlxSprite, point:FlxPoint) sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height);

	/**
	 *  Sets the midpoint position of a FlxSprite using a FlxPoint
	 *  @param sprite	input sprite
	 *  @param point	midpoint position
	 */
	public static inline function set_midpoint_position(sprite:FlxSprite, point:FlxPoint) sprite.setPosition(point.x - sprite.width * 0.5, point.y - sprite.height * 0.5);

	/**
	 *  Add animations from JSON file
	 *  @param sprite	input sprite
	 *  @param json		json array of objects with fields { "name":string, "frames":number[], "speed":number, "loop":boolean }
	 */
	public static inline function add_animations_from_json(sprite:FlxSprite, json:String)
	{
		var anim_data:Array<SpriteAnimation> = json.getText().parse();
		for (animation in anim_data) add_animation(sprite, animation);
	}

	static inline function add_animation(sprite:FlxSprite, animation:SpriteAnimation) sprite.animation.add(animation.name, animation.frames, animation.speed.to_int(), animation.loop == null ? true : animation.loop);

}

typedef SpriteAnimation = {
	name:String,
	frames: Array<Int>,
	speed: Int,
	?loop: Bool
}