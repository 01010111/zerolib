package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;

class CallbackAfterTimer extends Component
{

	var timer:Float = 0;
	var callback: Void -> Void;

	/**
	 * Creates a timer object that executes a callback function when time has run out. Use reset() to start timer.
	 * @param callback	callback function
	 * @param name 		component name
	 */
	public function new(callback:Void -> Void, name:String = 'callback_after_timer')
	{
		super(name);
		this.callback = callback;
	}

	/**
	 * Start the timer with a given time
	 * @param time 
	 */
	public function reset(time:Float)
	{
		timer = time;
	}

	@:dox(hide)
	override public function update(dt:Float)
	{
		if (timer <= 0) return;
		timer -= dt;
		if (timer <= 0) callback();
	}

}