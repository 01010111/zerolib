package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;

class KillTimer extends Component
{

	public var life_span:Float;
	public var life_time:Float;
	var run:Bool;

	public function new(life_span:Float, start_now:Bool = true)
	{
		this.life_span = life_span;
		super('kill timer', ['timer', 'kill']);
		reset();
		if (start_now) start();
	}

	public function start()
	{
		run = true;
	}

	public function stop()
	{
		run = false;
	}

	public function reset()
	{
		life_time = 0;
	}

	override public function update(e:Float)
	{
		if (!run) return;
		life_time += e;
		if (life_time >= life_span)
		{
			e.kill();
			stop();
		}
	}

}