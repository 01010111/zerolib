package zero.extensions;

class EnumExt
{

	public static inline function all<T>(e:Enum<T>):Array<T> return [for (e in Type.allEnums(e)) e];

}