package zero.utilities;

class EventBus
{

	static var listeners:Map<String, Array<Dynamic -> Void>> = new Map();

	public static function dispatch(name:String, data:Dynamic) {
		if (!listeners.exists(name)) return;
		for (listener in listeners[name]) if (listener != null) listener(data);
	}

	public static function register_listener(listener:Dynamic -> Void, name:String) {
		if (!listeners.exists(name)) listeners.set(name, []);
		listeners[name].push(listener);
	}

	public static function deregister_listener(listener:Dynamic -> Void, name:String) {
		if (!listeners.exists(name)) return;
		listeners[name].remove(listener);
	}

	public static function deregister_all() {
		for (key in listeners.keys()) listeners.set(key, []);
	}

}