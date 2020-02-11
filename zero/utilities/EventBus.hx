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

	public static function dispatch(name:String, ?data:Dynamic) {
		if (!listeners.exists(name)) return;
		for (listener in listeners[name]) if (listener != null) listener(data);
	}

	public static function listen(listener:?Dynamic -> Void, name:String) {
		if (!listeners.exists(name)) listeners.set(name, []);
		listeners[name].push(listener);
	}

	public static function unlisten(listener:?Dynamic -> Void, name:String) {
		if (!listeners.exists(name)) return;
		listeners[name].remove(listener);
	}

	public static function unlisten_all() {
		for (key in listeners.keys()) listeners.set(key, []);
	}

	public static function unlisten_signal(name:String) {
		listeners.remove(name);
	}

}