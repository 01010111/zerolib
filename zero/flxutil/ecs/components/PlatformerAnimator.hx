package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;
import flixel.FlxObject.*;

using Math;

/**
 * An Animator component for a basic Platformer entity
 */
class PlatformerAnimator extends Component
{

	var idle:String;
	var walk:String;
	var jump:String;
	var fall:String;

	/**
	 * Creates a new Animator component for a platformer entity
	 * @param idle	Idle animation name
	 * @param walk	Walk animation name
	 * @param jump	Jump animation name
	 * @param fall	Fall animation name
	 */
	public function new(idle:String = 'idle', walk:String = 'walk', jump:String = 'jump', fall:String = 'fall')
	{
		super('platformer_animation');
		this.idle = idle;
		this.walk = walk;
		this.jump = jump;
		this.fall = fall;
	}

	@:dox(hide)
	override function update(dt:Float)
	{
		super.update(dt);
		entity.animation.play(animate());
	}

	function animate():String
	{
		return entity.isTouching(FLOOR) ? velocity.x.abs() > 0 ? walk : idle : velocity.y > 0 ? jump : fall;
	}

}