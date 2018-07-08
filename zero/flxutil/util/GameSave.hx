package zero.flxutil.util;

import flixel.util.FlxSave;

/**
 *  A generic class for saving your game
 */
class GameSave
{

	static var SAVE_FILE:FlxSave;

	/**
	 *  Call this before saving or loading!
	 *  @param save_slot	the name of your save file
	 */
	public static function INIT(save_slot:String)
	{
		SAVE_FILE = new FlxSave();
		SAVE_FILE.bind(save_slot);
	}

	/**
	 *  Save data to file
	 *  @param data	Dynamic object with data to save (make sure it matches the structure of what you're trying to LOAD later!)
	 */
	public static function SAVE(data:Dynamic)
	{
		SAVE_FILE.data.game_data = data;
		SAVE_FILE.flush();
	}

	/**
	 *  Load data from file (make sure it matches the structure of what you SAVED earier!)
	 *  @return Null<Dynamic>
	 */
	public static function LOAD():Null<Dynamic> return SAVE_FILE.data.game_data;

}