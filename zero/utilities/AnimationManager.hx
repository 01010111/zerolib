package zero.utilities;

import zero.utilities.Tween;

using Math;

/**
	An animation manager utility, framework agnostic. Dependent on `zero.utilities.Tween` so make sure somewhere in your project you're updating `Tween.update()`!
	
	**Usage:**
	
	```haxe
	class AnimatedSprite {
		var animation:AnimationManager;
		var frames:Array<Graphic>;

		public function new() {
			animation = new AnimationManager({ on_frame_change: enter_frame });
			animation.add({
				name: 'walk',
				frames: [0,1,2,3],
				duration: 0.5,
			});
			animation.play('walk');
		}

		function enter_frame(index:Int) {
			graphic = frames[index]; // dependent on engine/framework!
		}
	}
	```
**/
class AnimationManager {

	public var current:AnimationData;
	public var animation_index(default, set):Int = -1;
	public var active(get, set):Bool;
	public var duration(get, set):Float;
	var data:Map<String, AnimationData> = [];
	var on_frame_change:Int -> Void;
	var tween:Tween;
	
	public function new(options:AnimationOptions) {
		on_frame_change = options.on_frame_change;
	}

	public function add(data:AnimationData) {
		if (data.duration == null) data.duration = 1;
		if (data.type == null) data.type = LOOP_FORWARDS;
		if (data.ease == null) data.ease = (n) -> n;
		this.data.set(data.name, data);
		return this;
	}
	
	public function play(name:String, period:Float = 0, force:Bool = false) {
		if (!data.exists(name)) return;
		if (current != null && current.name == name && !force) return;
		current = this.data[name];
		animation_index = 0;
		if (tween != null) tween.active = false;
		tween = Tween.get(this).duration(current.duration).ease(current.ease).set_period(period).type(current.type).prop({ animation_index: current.frames.length - 1 });
		if (current.on_complete != null) tween.on_complete(current.on_complete);
		on_frame_change(current.frames[0]);
	}

	function set_animation_index(n:Int) {
		if (current == null) return n;
		n = n.round() % current.frames.length;
		if (animation_index == n) return n;
		on_frame_change(current.frames[n]);
		return animation_index = n;
	}

	public function pause() {
		if (tween == null) return;
		tween.active = false;
	}

	public function resume() {
		if (tween == null) return;
		tween.active = true;
	}

	public function destroy() {
		tween.destroy();
		data.clear();
		current = null;
	}

	function get_active() {
		return tween.active;
	}

	function set_active(v:Bool) {
		return tween.active = v;
	}

	function get_duration() {
		return tween.get_duration();
	}

	function set_duration(v:Float) {
		tween.set_duration(v);
		return v;
	}

	public function get_period() {
		if (tween == null || !tween.active) return 0.0;
		else return tween.get_period();
	}

}

typedef AnimationOptions = {
	on_frame_change:Int -> Void,
}

typedef AnimationData = {
	name:String,
	frames:Array<Int>,
	?duration:Float,
	?type:TweenType,
	?ease:Float -> Float,
	?on_complete:Void -> Void,
}

typedef PlayOptions = {
	?period:Float
}