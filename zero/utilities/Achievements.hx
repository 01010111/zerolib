package zero.utilities;

using zero.utilities.EventBus;
using Std;

class Achievements
{

	static var data:Map<String, Bool>;
	static var callback:String -> Void = (s) -> {};

	public static function get_data():Map<String, Bool> return data;
	public static function set_data(map:Map<Dynamic, Bool>)  data = [ for (key in map.keys()) Std.string(key) => map[key] ];

	public static function set_callback(fn:String -> Void) callback = fn;

	public static function get_achievement(name:Dynamic) {
		if (!data.exists(name.string())) return trace('Achievement does not exist!');
		if (data[name.string()]) return;
		data.set(name.string(), true);
		callback(name.string());
	}

	public static function listen(name:Dynamic) ((?_) -> get_achievement(name.string())).register_listener(name.string());

}