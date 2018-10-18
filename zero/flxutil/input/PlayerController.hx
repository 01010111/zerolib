package zero.flxutil.input;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.util.FlxTimer;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import zero.flxutil.input.Controller;

/**
 *  A Player Controller class for quick and easy controller setup
 */
class PlayerController extends Controller
{

	var gamepad:Gamepad;
	var binding:Map<ControllerButton, FlxKey> = new Map();

	/**
	 *  Creates a new player controller with given options
	 *  @param options	ControllerOptions - {
	 *  	binding:Map<ControllerButton, FlxKey>	controller bindings,
	 *  	density:ControllerDensity				NES/GENESIS/SNES,
	 *  	gamepad_options:GamepadOptions - {
	 *  		id:Int								Gamepad ID,
	 *  		connect_timer:Float					how often to try to connect,
	 *  		binding:Map<ControllerButton, FlxGamepadInputID>	gamepad bindings,
	 *  		on_connect:Void -> Void				on connect callback
	 *  		on_disconnect:Void -> Void			on disconnect callback,
	 *  	}
	 *  }
	 */
	public function new(?options:ControllerOptions)
	{
		super();
		if (options == null) options = { binding: Bindings.NES_SAFE_ARROWS };
		init(options);
	}

	function init(options:ControllerOptions)
	{
		if (options.binding != null) binding = options.binding;
		else if (options.density != null)
		{
			binding = switch(options.density)
			{
				case NES: Bindings.NES_SAFE_ARROWS;
				case GENESIS: Bindings.GENESIS_QWERTY_ARROWS;
				case SNES: Bindings.SNES_QWERTY_ARROWS;
			}
		}
		else binding = Bindings.NES_SAFE_ARROWS;
		gamepad = options.gamepad_options == null ? new Gamepad() : new Gamepad(options.gamepad_options);
	}

	/**
	 *  Add this controller (and gamepad controller) to state, use instead of [FlxState].add(player_controller)
	 */
	override public function add()
	{
		super.add();
		gamepad.add();
	}

	/**
	 *  Bind a button to a keyboard key
	 *  @param button	button
	 *  @param key		key
	 */
	public function bind(button:ControllerButton, key:FlxKey) binding.set(button, key);

	override function set(dt:Float) for (button in binding.keys()) set_button(button, FlxG.keys.anyPressed([binding[button]]) || gamepad.pressed(button));

}

/**
 *  A Gamepad controller class
 */
class Gamepad extends Controller
{

	var pad:FlxGamepad;
	var id:Int;
	var on_connect:Void -> Void = function () { trace('Controller connected!'); };
	var on_disconnect:Void -> Void = function () { trace('Controller disconnected!'); };
	var connect_timer:Float;
	var connected = false;

	var binding:Map<ControllerButton, FlxGamepadInputID>;

	/**
	 *  Creates a new Gamepad controller with given options
	 *  @param options	GamepadOptions - {
	 *  	id:Int								Gamepad ID,
	 *  	connect_timer:Float					how often to try to connect,
	 *  	binding:Map<ControllerButton, FlxGamepadInputID>	gamepad bindings,
	 *  	on_connect:Void -> Void				on connect callback
	 *  	on_disconnect:Void -> Void			on disconnect callback,
	 *  }
	 */
	public function new(?options:GamepadOptions)
	{
		if (options == null) options = {
			id: 0,
			connect_timer: 1
		}
		super();
		id = options.id;
		connect_timer = options.connect_timer;
		if (options.on_connect != null) on_connect = options.on_connect;
		if (options.on_disconnect != null) on_disconnect = options.on_disconnect;
		binding = options.binding == null ? Bindings.GAMEPAD : options.binding;
		connect();
	}

	function connect(?t:FlxTimer)
	{
		if (FlxG.gamepads.getByID(id) != null) pad = FlxG.gamepads.getByID(id);
		else new FlxTimer().start(connect_timer, connect);
	}

	@:dox(hide)
	override public function update(dt:Float)
	{
		if (!connected && pad != null)
		{
			connected = true;
			on_connect();
		}
		else if (connected && pad == null)
		{
			connected = false;
			on_disconnect();
		}
		if (pad == null) return;
		super.update(dt);
	}

	override function set(dt:Float)
	{
		for (button in binding.keys()) set_button(button, pad.anyPressed([binding[button]]));
	}

}

typedef ControllerOptions =
{
	?binding:Map<ControllerButton, FlxKey>,
	?density:ControllerDensity,
	?gamepad_options:GamepadOptions
}

typedef GamepadOptions =
{
	id:Int,
	connect_timer:Float,
	?binding:Map<ControllerButton, FlxGamepadInputID>,
	?on_connect:Void -> Void,
	?on_disconnect:Void -> Void
}

enum ControllerDensity
{
	NES;		// A, B, DPAD, START, SELECT
	GENESIS;	// A, B, X, DPAD, START, SELECT
	SNES;		// A, B, X, Y, DPAD, BUMPERS, START, SELECT
}

/**
 *  A collection of default bindings
 */
class Bindings
{

	public static var NES_SAFE_ARROWS:Map<ControllerButton, FlxKey> = [
		FACE_A =>		FlxKey.X,
		FACE_B =>		FlxKey.C,
		DPAD_UP =>		FlxKey.UP,
		DPAD_DOWN =>	FlxKey.DOWN,
		DPAD_LEFT =>	FlxKey.LEFT,
		DPAD_RIGHT =>	FlxKey.RIGHT,
		UTIL_START =>	FlxKey.ENTER,
		UTIL_SELECT =>	FlxKey.TAB
	];

	public static var NES_QWERTY_ARROWS:Map<ControllerButton, FlxKey> = [
		FACE_A =>		FlxKey.Z,
		FACE_B =>		FlxKey.X,
		DPAD_UP =>		FlxKey.UP,
		DPAD_DOWN =>	FlxKey.DOWN,
		DPAD_LEFT =>	FlxKey.LEFT,
		DPAD_RIGHT =>	FlxKey.RIGHT,
		UTIL_START =>	FlxKey.ENTER,
		UTIL_SELECT =>	FlxKey.TAB
	];

	public static var GENESIS_QWERTY_ARROWS:Map<ControllerButton, FlxKey> = [
		FACE_A =>		FlxKey.Z,
		FACE_B =>		FlxKey.X,
		FACE_X =>		FlxKey.C,
		DPAD_UP =>		FlxKey.UP,
		DPAD_DOWN =>	FlxKey.DOWN,
		DPAD_LEFT =>	FlxKey.LEFT,
		DPAD_RIGHT =>	FlxKey.RIGHT,
		UTIL_START =>	FlxKey.ENTER,
		UTIL_SELECT =>	FlxKey.TAB
	];

	public static var SNES_QWERTY_ARROWS:Map<ControllerButton, FlxKey> = [
		FACE_A =>		FlxKey.X,
		FACE_B =>		FlxKey.S,
		FACE_X =>		FlxKey.Z,
		FACE_Y =>		FlxKey.A,
		DPAD_UP =>		FlxKey.UP,
		DPAD_DOWN =>	FlxKey.DOWN,
		DPAD_LEFT =>	FlxKey.LEFT,
		DPAD_RIGHT =>	FlxKey.RIGHT,
		BUMPER_LEFT =>	FlxKey.Q,
		BUMPER_RIGHT =>	FlxKey.W,
		UTIL_START =>	FlxKey.ENTER,
		UTIL_SELECT =>	FlxKey.TAB
	];

	public static var GAMEPAD:Map<ControllerButton, FlxGamepadInputID> = [
		FACE_A =>				FlxGamepadInputID.A,
		FACE_B =>				FlxGamepadInputID.B,
		FACE_X =>				FlxGamepadInputID.X,
		FACE_Y =>				FlxGamepadInputID.Y,
		DPAD_UP =>				FlxGamepadInputID.DPAD_UP,
		DPAD_DOWN =>			FlxGamepadInputID.DPAD_DOWN,
		DPAD_LEFT =>			FlxGamepadInputID.DPAD_LEFT,
		DPAD_RIGHT =>			FlxGamepadInputID.DPAD_RIGHT,
		BUMPER_LEFT =>			FlxGamepadInputID.LEFT_SHOULDER,
		BUMPER_RIGHT =>			FlxGamepadInputID.RIGHT_SHOULDER,
		TRIGGER_LEFT =>			FlxGamepadInputID.LEFT_TRIGGER,
		TRIGGER_RIGHT =>		FlxGamepadInputID.RIGHT_TRIGGER,
		UTIL_START =>			FlxGamepadInputID.START,
		UTIL_SELECT =>			FlxGamepadInputID.BACK,
		LEFT_ANALOG_UP =>		FlxGamepadInputID.LEFT_STICK_DIGITAL_UP,
		LEFT_ANALOG_DOWN =>		FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN,
		LEFT_ANALOG_LEFT =>		FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT,
		LEFT_ANALOG_RIGHT =>	FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT,
		LEFT_ANALOG_CLICK =>	FlxGamepadInputID.LEFT_ANALOG_STICK,
		RIGHT_ANALOG_UP =>		FlxGamepadInputID.RIGHT_STICK_DIGITAL_UP,
		RIGHT_ANALOG_DOWN =>	FlxGamepadInputID.RIGHT_STICK_DIGITAL_DOWN,
		RIGHT_ANALOG_RIGHT =>	FlxGamepadInputID.RIGHT_STICK_DIGITAL_LEFT,
		RIGHT_ANALOG_RIGHT =>	FlxGamepadInputID.RIGHT_STICK_DIGITAL_RIGHT,
		RIGHT_ANALOG_CLICK =>	FlxGamepadInputID.RIGHT_ANALOG_STICK,
		GUIDE =>				FlxGamepadInputID.GUIDE,
	];

}