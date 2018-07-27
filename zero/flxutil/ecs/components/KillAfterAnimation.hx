package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;

class KillAfterAnimation extends Component
{

	public function new()
	{
		super('kill_after_animation');
	}

	override public function update(dt:Float)
	{
		if (entity.animation.finished) entity.kill();
	}

}