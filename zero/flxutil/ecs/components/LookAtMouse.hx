package zero.flxutil.ecs.components;

import flixel.FlxG;
import zero.flxutil.ecs.Component;

using Math;
using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

/**
 * A simple component that rotates an entity to face the mouse
 */
class LookAtMouse extends Component
{

	var lerp:Float = 0.25;

	/**
	 * Creates a new component that rotates an entity to face the mouse
	 * @param lerp	the rate of change in the angle (0-1)
	 */
	public function new(lerp:Float = 0.25)
	{
		this.lerp = lerp.min(1).max(0.01);
		super('look_at_mouse');
	}

	@:dox(hide)
	override public function update(dt:Float)
	{
		var target_angle = entity.getMidpoint().get_angle_between(FlxG.mouse.getPosition());
		angle = angle.translate_to_nearest_angle(target_angle);
		angle += (target_angle - angle) * lerp;
	}
	
	/**
	 * Change the rate of change in the angle (0-1)
	 * @param lerp
	 */
	public inline function set_lerp(lerp:Float) this.lerp = lerp.min(1).max(0.01);

}