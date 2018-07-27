package zero.flxutil.ecs.components;

import flixel.FlxObject.*;
import zero.flxutil.input.Controller;
import zero.flxutil.ecs.Component;

/**
 * A Component to make an entity in a platformer Jump
 */
class PlatformerJumper extends Component
{

	var jump_power:Float;
	var jump_button:ControllerButton;
	var controller:Controller;
	var coyote_time:Float;
	
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
	}

	@:dox(hide)
	override public function update(dt:Float)
	{
		if (coyote_timer > 0) coyote_timer -= dt;
		if (just_jumped_timer > 0) just_jumped_timer -= dt;

		if (entity.wasTouching & FLOOR > 0) coyote_timer = coyote_time;
		if (controller.just_pressed(jump_button)) just_jumped_timer = coyote_time;
		if (controller.just_released(jump_button) && entity.velocity.y < 0) entity.velocity.y *= 0.5;

		if (just_jumped_timer <= 0 || coyote_timer <= 0) return;
		entity.velocity.y = -jump_power;
		just_jumped_timer = 0;
	}

}

typedef JumperOptions = 
{
	controller:Controller,
	jump_power:Float,
	jump_button:ControllerButton,
	coyote_time:Float
}