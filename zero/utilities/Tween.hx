package zero.utilities;

using Math;
using Std;
using zero.extensions.FloatExt;

/**
 * A utility for interpolating between numbers over time
 * 
 * **Usage**
 * 
 * - Import into your project. `import zero.utilities.Tween;`

 */
 /**
	 A utility for interpolating between numbers over time

	 **Usage**
	 
	 Before any tweens can be active, make sure you're updating the tween manager in your project with the time from the last frame (delta time):
	 ```haxe
		Tween.update(delta_time);
	 ```

	 Then you can create a tween by passing the object with the variable to tween, and then any other settings. For instance, this will move an object's position to x: 50, y: 100 in 2 seconds:
	 ```haxe
	 	Tween.get(my_object).prop({ x: 50, y: 100 }).duration(2);
	 ```
 **/
 class Tween {
			
	static var active_tweens:Array<Tween> = [];
	static var pool:Array<Tween> = [];

	/**
	 * Initialize and return a new Tween
	 */
	 public static function get(target:Dynamic) {
		 var tween = pool.shift();
		 if (tween == null) tween = new Tween();
		 tween.init(target);
		 tween.active = true;
		 active_tweens.push(tween);
		 return tween;
	}
	
	/**
	 * Updates all active Tweens
	 */
	public static function update(dt:Float) {
		for (tween in active_tweens) tween.update_tween(dt);
	}

	/**
	 * Tween.active determines whether to update a tween or not
	 */
	public var active:Bool = true;
	var data:TweenData;
	var period:Float;
	var reverse:Bool;

	/**
	 * Sets the duration of a Tween
	 */
	 public function duration(time:Float) {
		data.duration = time;
		return this;
	}

	/**
	 * Sets the properties and values to use in a Tween
	 */
	public function prop(properties:Dynamic) {
		for (field in Reflect.fields(properties)) {
			var start = Reflect.getProperty(data.target, field);
			if (data.target.isOfType(Array)) {
				switch field {
					case 'x', 'r' : start = data.target[0];
					case 'y', 'g' : start = data.target[1];
					case 'z', 'b', 'width' : start = data.target[2];
					case 'w', 'a', 'height' : start = data.target[3];
				}
			}
			data.properties.set(field, {
				start: start == null ? 0 : start,
				end: Reflect.field(properties, field),
			});
		}
		return this;
	}

	public function from_to(field:String, from:Dynamic, to:Dynamic) {
		data.properties.set(field, { start: from, end: to });
		return this;
	}

	/**
	 * Sets the easing function to be used by a Tween
	 */
	public function ease(ease:Float -> Float) {
		data.ease = ease;
		return this;
	}

	/**
	 * Sets a period of time to wait before a Tween becomes active
	 */
	public function delay(time:Float) {
		data.delay = time;
		data.delay_ref = time;
		return this;
	}

	/**
	 * Sets a callback function that is called when a Tween completes
	 */
	public function on_complete(fn:Void -> Void) {
		data.on_complete = fn;
		return this;
	}

	/**
	 * Sets the playback type of a Tween
	 */
	public function type(type:TweenType) {
		data.type = type;
		reverse = switch type {
			case SINGLE_SHOT_FORWARDS | LOOP_FORWARDS | PING_PONG: false;
			case SINGLE_SHOT_BACKWARDS | LOOP_BACKWARDS: true;
		}
		return this;
	}

	/**
	 * Sets the period or progress of a Tween (0-1)
	 */
	public function set_period(period:Float) {
		this.period = period.min(1).max(0);
		return this;
	}

	/**
	 * Get the duration of a Tween
	 */
	public function get_duration():Float {
		if (data == null) return -1;
		return data.duration;
	}

	/**
	 * Sets the duration of a Tween
	 */
	public function set_duration(duration:Float) {
		if (data == null) return;
		data.duration = duration;
	}

	/**
	 * Cancels a Tween and recycles it
	 */
	 public function destroy() {
		data = null;
		active_tweens.remove(this);
		active = false;
		pool.push(this);
	}

	private function new() {}

	function init(target:Dynamic) {
		data = get_default_data(target);
		period = 0;
		reverse = false;
	}

	function get_default_data(target:Dynamic):TweenData {
		return {
			target: target,
			duration: 1,
			properties: [],
			ease: (f) -> f,
			delay: 0,
			delay_ref: 0,
			on_complete: () -> {},
			type: SINGLE_SHOT_FORWARDS,
		}
	}

	public function update_tween(dt:Float) {
		if (!active) return;
		dt = update_dt(dt);
		update_period(dt);
	}

	function update_dt(dt:Float):Float {
		if (data.delay > 0) {
			data.delay -= dt;
			if (data.delay > 0) return 0;
			dt = -data.delay;
		}
		return dt;
	}

	function update_period(dt:Float) {
		if (dt == 0) return;
		var d = dt/data.duration;
		period += reverse ? -d : d;
		period = period.min(1).max(0);
		if (period == 0 || period == 1) complete();
		else apply();
	}

	function complete() {
		apply();
		data.on_complete();
		switch data.type {
			case SINGLE_SHOT_FORWARDS | SINGLE_SHOT_BACKWARDS: destroy();
			case LOOP_FORWARDS | LOOP_BACKWARDS | PING_PONG: reset();
		}
	}

	function reset() {
		if (data.type == PING_PONG) reverse = !reverse;
		data.delay = data.delay_ref;
		period = reverse ? 1 : 0;
	}

	function apply() {
		if (data == null) return;
		var eased_period = data.ease(period);
		for (field => property in data.properties) {
			var val = eased_period.map(0, 1, property.start, property.end);
			if (data.target.isOfType(Array)) {
				switch field {
					case 'x', 'r' : data.target[0] = val;
					case 'y', 'g' : data.target[1] = val;
					case 'z', 'b', 'width' : data.target[2] = val;
					case 'w', 'a', 'height' : data.target[3] = val;
				}
			}
			else Reflect.setProperty(data.target, field, val);
		}
	}

}

typedef TweenData = {
	target:Dynamic,
	duration:Float,
	properties:Map<String, TweenProperty>,
	ease:Float -> Float,
	delay:Float,
	delay_ref:Float,
	on_complete:Void -> Void,
	type:TweenType,
}

typedef TweenProperty = {
	start:Dynamic,
	end:Dynamic,
}

enum TweenType {
	SINGLE_SHOT_FORWARDS;
	SINGLE_SHOT_BACKWARDS;
	LOOP_FORWARDS;
	LOOP_BACKWARDS;
	PING_PONG;
}