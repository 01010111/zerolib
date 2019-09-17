package zero.utilities;

/**
 * A Simple Pseudo-Random Number Generator
 * 
 * **Usage:**
 * 
 * - get a random number using either `int()` or `float()`
 * - or get a random number within a specific range using `int_range(min, max)` or `float_range(min, max)`
 * - set a unique seed using `set_seed()` or `set_seed_from_string()`
 */
class PRNG
{

	static var seed:UInt = set_seed_from_string(Date.now().toString());
	public static function int():UInt return gen();
	public static function float():Float return gen() / 2147483647;
	public static function int_range(min:Float, max:Float):UInt return Math.round(min + (((max += .4999) - (min -= .4999)) * float()));
	public static function float_range(min:Float, max:Float):Float return min + ((max - min) * float());

	public static function set_seed(i:UInt) return seed = i;
	public static function set_seed_from_string(s:String)
	{
		var hash = 5381;
		for (c in s.split('')) hash = ((hash << 5) + hash * 33) ^ c.charCodeAt(0);
		return seed = hash;
	}

	static function gen():UInt return seed = (seed * 16807) % 2147483647;

}