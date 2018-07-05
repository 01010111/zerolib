package zero.util;

/**
 *  @author 01010111
 */
class IntPoint
{

    public var x:Int;
    public var y:Int;

    public function new(x:Int = 0, ?y:Int) set(x, y);

	public function set(x:Int = 0, ?y:Int)
	{
		this.x = x;
		this.y = y == null ? x : y;
	}

    public inline function compare(ip:IntPoint):Bool return (ip.x == x && ip.y == y);
    public inline function add_to(ip:IntPoint) set(x + ip.x, y + ip.y);
	public inline function copy():IntPoint return new IntPoint(x, y);
    public static inline function add(ip1, ip2):IntPoint return new IntPoint(ip1.x + ip2.x, ip1.y + ip2.y);

}