package zero.flxutil.ecs.components;

import flixel.FlxObject.*;
import zero.flxutil.input.Controller;
import zero.flxutil.ecs.Component;

/**
 * A Component to make an entity in a platformer Walk
 */
class PlatformerWalker extends Component
{

	var controller:Controller;
	var walk_speed:Float;
	var accel_amt:Float;
	var drag_amt:Float;

	/**
	 * Create a new Walker component with options
	 * @param options 
	 */
	public function new(options:WalkerOptions)
	{
		super('walker');
		controller = options.controller;
		walk_speed = options.walk_speed;
		accel_amt = options.acceleration_force;
		drag_amt = options.drag_force;
	}

	override function on_add()
	{
		entity.maxVelocity.x = walk_speed;
		drag.x = drag_amt;
	}

	override public function update(dt:Float)
	{
		acceleration.x = 0;
		if (controller.get_pressed(DPAD_LEFT)) acceleration.x -= accel_amt;
		if (controller.get_pressed(DPAD_RIGHT)) acceleration.x += accel_amt;
		if (entity.facing == LEFT && velocity.x > 0 || entity.facing == RIGHT && velocity.x < 0) velocity.x *= 0.5;
		entity.facing = acceleration.x < 0 ? LEFT : acceleration.x > 0 ? RIGHT : entity.facing;
	}

}

typedef WalkerOptions =
{
	controller:Controller,
	walk_speed:Float,
	acceleration_force:Float,
	drag_force:Float
}