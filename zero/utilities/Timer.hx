package zero.utilities;

/**
 * A Timer that will execute a function once a specified time limit runs out
 * 
 * **Usage**
 * 
 * - Import into your project. `import zero.utilities.Timer;`
 * - Create a new timer! `Timer.get(1, () -> trace('hiya world'), 10);` <- traces "hiya world" every 1 second 10 times
 * - Make sure to update timers by including this in your game loop: `Timer.update(delta_time);`
 * - You can store Timers as variables - `var timer = Timer.get(10, () -> do_thing());`
 * - Which will let you pause, unpause, or cancel it - `timer.cancel();`
 * - You can cancel all active timers as well - `Timer.cancel_all();`
 */
class Timer {
	
	static var timers:Array<Timer> = [];
	static var pool:Array<Timer> = [];
	static var epsilon:Float = 1e-8;

	public static function get(time:Float, fn:Void -> Void, repeat:Int = 1):Timer {
		var timer = pool.length > 0 ? pool.shift() : new Timer();
		timer.time = time;
		timer.fn = fn;
		timer.repeat = repeat;
		timer.paused = false;
		timer.elapsed = 0;
		timers.push(timer);
		return timer;
	}

	public static function update(dt:Float) for (timer in timers) timer.run(dt);

	public var active(get, never):Bool;
	function get_active() return timers.indexOf(this) >= 0;

	var time:Float;
	var elapsed:Float;
	var fn:Void -> Void;
	var repeat:Int;
	var paused:Bool;

	function new() {}

	public static function cancel_all() for (timer in timers) timer.cancel();
	public function cancel() if (timers.remove(this)) pool.push(this);
	public function pause() paused = true;
	public function unpause() paused = false;

	function run(dt:Float) {
		if (paused) return;
		elapsed += dt;
		if (time - elapsed > epsilon) return;
		fn();
		elapsed = 0;
		repeat--;
		if (repeat != 0) return;
		cancel();
	}

	public function toString():String return('time left: ${time - elapsed}');

}