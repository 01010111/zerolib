package zero.flxutil.input;

import flixel.FlxG;
import flixel.FlxBasic;

using Math;

class Controller extends FlxBasic
{

	public var state:Map<ControllerButton, Bool> = new Map();

	var history:Array<Map<ControllerButton, Bool>> = [];
	var max_history:Int = 1;

	public function new()
	{
		super();
		for (button in Type.allEnums(ControllerButton)) state.set(button, false);
	}

	override public function update(dt:Float)
	{
		var last_state:Map<ControllerButton, Bool> = new Map();
		for (key in state.keys()) last_state.set(key, state[key]);
		history.push(last_state);
		while (history.length > max_history) history.shift();
		super.update(dt);
		set(dt);
	}

	function set(dt:Float){}
	public function add() FlxG.state.add(this);
	public inline function get_history():Array<Map<ControllerButton, Bool>> return history;
	public inline function set_max_history(length:Int) max_history = length.max(1).floor();
	public inline function set_button(button:ControllerButton, pressed:Bool) state.set(button, pressed);
	public inline function get_pressed(button:ControllerButton):Bool return state[button];
	public inline function get_just_pressed(button:ControllerButton):Bool return state[button] && !history[history.length - 1][button];
	public inline function get_just_released(button:ControllerButton):Bool return !state[button] && history[history.length - 1][button];

}

enum ControllerButton
{
	FACE_A;
	FACE_B;
	FACE_X;
	FACE_Y;
	DPAD_UP;
	DPAD_DOWN;
	DPAD_LEFT;
	DPAD_RIGHT;
	UTIL_START;
	UTIL_SELECT;
	BUMPER_LEFT;
	BUMPER_RIGHT;
	TRIGGER_LEFT;
	TRIGGER_RIGHT;
	LEFT_ANALOG_UP;
	LEFT_ANALOG_DOWN;
	LEFT_ANALOG_LEFT;
	LEFT_ANALOG_RIGHT;
	LEFT_ANALOG_CLICK;
	RIGHT_ANALOG_UP;
	RIGHT_ANALOG_DOWN;
	RIGHT_ANALOG_LEFT;
	RIGHT_ANALOG_RIGHT;
	RIGHT_ANALOG_CLICK;
	GUIDE;
}