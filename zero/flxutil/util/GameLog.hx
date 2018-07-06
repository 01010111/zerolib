package zero.flxutil.util;

import flixel.FlxG;

/**
 *  A generic class for logging events
 */
class GameLog
{

	static var GAME_LOG:String = '';

	/**
	 *  Logs a message to console (and debug console) with given severity
	 *  @param message	the message to log
	 *  @param severity	the severity of the log (ERROR/WARNING/INFO)
	 */
	public static function LOG(message:String, severity:LogSeverity)
	{
		message = '${Std.string(severity)}: $message';
		GAME_LOG += '$message\n';
		trace(message);
		#if debug
		switch (severity) {
			case ERROR:		FlxG.log.error(message);
			case WARNING:	FlxG.log.warn(message);
			case INFO:		FlxG.log.add(message);
		}
		#end
	}

	/**
	 *  traces and returns the current log history
	 *  @return	String
	 */
	public static function PRINT_LOG():String
	{
		trace(GAME_LOG);
		return GAME_LOG;
	}

}

enum LogSeverity
{
	ERROR;
	WARNING;
	INFO;
}