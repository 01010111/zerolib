package zero.utilities;

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

	var time:Float;
	var elapsed:Float;
	var fn:Void -> Void;
	var repeat:Int;
	var paused:Bool;

	function new() {}

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