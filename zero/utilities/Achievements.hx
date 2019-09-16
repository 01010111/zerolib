package zero.utilities;

using zero.utilities.EventBus;
using Std;

/**
 * Simple Bare-bones Achievements framework.
 * 
 * **Usage:**
 * 
 * - import it into your project `import zero.utilities.Achievements;`
 * - also use EventBus - `using zero.utilities.EventBus;`
 * - Set data from Map<String, Bool> (either to initialize Achievements or use saved data) using `Achievements.set_data(my_map);`
 * - Add listeners for individual achievements using `Achievements.listen('my achievement');` (also works with enums!)
 * - Trigger achievements using `"my achievement".dispatch();`
 * - Make sure to save your achievement data - you can retrive it with `Achievements.get_data();`
 */
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