package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;

class CallbackAfterTimer extends Component
{

	var timer:Float = 0;
	var callback: Void -> Void;

	public function new(callback:Void -> Void, name:String = 'callback_after_timer')
	{
		super(name);
		this.callback = callback;
	}

	public function reset(time:Float)
	{
		timer = time;
	}

	override public function update(dt:Float)
	{
		if (timer <= 0) return;
		timer -= dt;
		if (timer <= 0) callback();
	}

}