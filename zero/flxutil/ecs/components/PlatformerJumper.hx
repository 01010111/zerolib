package zero.flxutil.ecs.components;

import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.FlxObject.*;
import zero.flxutil.input.Controller;
import zero.flxutil.ecs.Component;

using zero.ext.flx.FlxTilemapExt;
using zero.ext.flx.FlxSpriteExt;

/**
 * A Component to make an entity in a platformer Jump
 */
class PlatformerJumper extends Component
{

	var jump_power:Float;
	var jump_button:ControllerButton;
	var controller:Controller;
	var coyote_time:Float;
	var jump_down:Bool;
	var tiles:FlxTilemap;
	
	var coyote_timer:Float;
	var just_jumped_timer:Float;

	/**
	 * Create a new Jumper component with options
	 * @param options 
	 */
	public function new(options:JumperOptions)
	{
		super('platformer_jumper');
		jump_power = options.jump_power;
		jump_button = options.jump_button;
		controller = options.controller;
		coyote_time = options.coyote_time;
		jump_down = options.jump_down != null;
		if (jump_down) tiles = options.jump_down.tiles;
	}

	@:dox(hide)
	override public function update(dt:Float)
	{
		if (coyote_timer > 0) coyote_timer -= dt;
		if (just_jumped_timer > 0) just_jumped_timer -= dt;

		if (jump_down && can_jump_down()) return;

		if (entity.wasTouching & FLOOR > 0) coyote_timer = coyote_time;
		if (controller.just_pressed(jump_button)) just_jumped_timer = coyote_time;
		if (controller.just_released(jump_button) && velocity.y < 0) velocity.y *= 0.5;

		if (just_jumped_timer <= 0 || coyote_timer <= 0) return;

		velocity.y = -jump_power;
		just_jumped_timer = 0;
	}

	function can_jump_down():Bool
	{
		if (!controller.just_pressed(jump_button) || !controller.pressed(DPAD_DOWN)) return false;
		if (tiles.get_collisions_from_point(entity.get_anchor().add(0, 1)) & 0x1000 == 0) y += FlxObject.SEPARATE_BIAS + 0.001;
		return true;
	}

}

typedef JumperOptions = 
{
	controller:Controller,
	jump_power:Float,
	jump_button:ControllerButton,
	coyote_time:Float,
	?jump_down:JumpDownOptions,
}

typedef JumpDownOptions =
{
	tiles:FlxTilemap,
}