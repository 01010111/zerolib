package zero.extensions;

class EnumExt
{

	/**
	 * Get an array of all enums, shortcut for Type.allEnums()
	 * @param e input
	 * @return Array<T> return [for (e in Type.allEnums(e)) e]
	 */
	public static inline function all<T>(e:Enum<T>):Array<T> return [for (e in Type.allEnums(e)) e];

}