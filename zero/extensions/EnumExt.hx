package zero.extensions;

using zero.extensions.EnumExt;
using zero.extensions.ArrayExt;

class EnumExt
{

	/**
	 * Get an array of all enums, shortcut for Type.allEnums()
	 * @param e input
	 * @return Array<T> return [for (e in Type.allEnums(e)) e]
	 */
	public static inline function all<T>(e:Enum<T>):Array<T> return [for (e in Type.allEnums(e)) e];

	/**
	 * Returns a random enum value from input
	 * @param e input
	 * @return T return e.all().get_random()
	 */
	public static inline function get_random<T>(e:Enum<T>):T return e.all().get_random();

}