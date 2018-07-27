package zero.flxutil.ecs.components;

import flixel.FlxObject;
import zero.flxutil.ecs.Component;

using Math;
using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

/**
 * A simple component that rotates an entity to face a target
 */
class LookAtTarget extends Component
{

	var target:FlxObject;
	var lerp:Float = 0.25;

	/**
	 * Creates a new component that rotates an entity to face a target
	 * @param target	the target at which to face
	 * @param lerp		the rate of change in the angle (0-1)
	 */
	public function new(target:FlxObject, lerp:Float = 0.25)
	{
		this.lerp = lerp.min(1).max(0.01);
		super('look_at_target');
		switch_target(target);
	}

	@:dox(hide)
	override function update(dt:Float)
	{
		var target_angle = entity.getMidpoint().get_angle_between(target.getMidpoint());
		angle = angle.translate_to_nearest_angle(target_angle);
		angle += (target_angle - angle) * lerp;
	}

	/**
	 * Switches targets
	 * @param new_target
	 */
	public inline function switch_target(new_target:FlxObject) target = new_target;
	
	/**
	 * Change the rate of change in the angle (0-1)
	 * @param lerp 
	 */
	public inline function set_lerp(lerp:Float) this.lerp = lerp.min(1).max(0.01);

}