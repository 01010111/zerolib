package zero.utilities;

using Std;

/**
 * Simple EventBus
 * 
 * **Usage**
 * - Assume `MyClass.listen = (data:Dynamic) -> trace(data.text)`
 * - Register listener `EventBus.register_listener(MyClass.listen);`
 * - Dispatch data `EventBus.dispatch({ text: 'hello world' });` this will trace: `hello world`
 * - Deregister listener when done: `EventBus.deregister_listener(MyClass.listen)`
 * - or deregister all listeners: `EventBus.deregister_all()`
 */
class EventBus
{

	static var listeners:Map<String, Array<?Dynamic -> Void>> = new Map();

	public static function dispatch(name:Dynamic, ?data:Dynamic) {
		if (!listeners.exists(name.string())) return;
		for (listener in listeners[name.string()]) if (listener != null) listener(data);
	}

	public static function register_listener(listener:?Dynamic -> Void, name:Dynamic) {
		if (!listeners.exists(name.string())) listeners.set(name.string(), []);
		listeners[name.string()].push(listener);
	}

	public static function deregister_listener(listener:?Dynamic -> Void, name:Dynamic) {
		if (!listeners.exists(name.string())) return;
		listeners[name.string()].remove(listener);
	}

	public static function deregister_all() {
		for (key in listeners.keys()) listeners.set(key, []);
	}

}