package zero.utilities;

using Std;

/**
 * Simple EventBus
 * 
 * **Usage:**
 * 
 * - Assume `MyClass.listener = (?data:Dynamic) -> trace(data.text)`
 * - Register listener `EventBus.listen(MyClass.listener, 'hello');`
 * - Dispatch data `EventBus.dispatch('hello', { text: 'hello world' });` this will trace: `hello world`
 * - Deregister listener when done: `EventBus.unlisten(MyClass.listen, 'hello')`
 * - or deregister all listeners: `EventBus.unlisten_all()`
 */
class EventBus
{

	static var listeners:Map<String, Array<?Dynamic -> Void>> = new Map();

	public static function dispatch(name:Dynamic, ?data:Dynamic) {
		if (!listeners.exists(name.string())) return;
		for (listener in listeners[name.string()]) if (listener != null) listener(data);
	}

	public static function listen(listener:?Dynamic -> Void, name:Dynamic) {
		if (!listeners.exists(name.string())) listeners.set(name.string(), []);
		listeners[name.string()].push(listener);
	}

	public static function unlisten(listener:?Dynamic -> Void, name:Dynamic) {
		if (!listeners.exists(name.string())) return;
		listeners[name.string()].remove(listener);
	}

	public static function unlisten_all() {
		for (key in listeners.keys()) listeners.set(key, []);
	}

}