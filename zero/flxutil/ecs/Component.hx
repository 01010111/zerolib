package zero.flxutil.ecs;

import flixel.math.FlxPoint;
import zero.flxutil.ecs.Entity;

class Component
{

	var id:String;
	var tags:Array<String> = [];
	var entity:Entity;
	var transform:Transform;

	public function get_id():String
	{
		return id;
	}

	public function has_tag(tag:String):Bool
	{
		for (t in tags) if (t == tag) return true;
		return false;
	}

	public function new(id:String, ?tags:Array<String>)
	{
		this.id = id;
		this.tags = tags == null ? [] : tags;
	}

	public function add_to(entity:Entity)
	{
		this.entity = entity;
		transform = new Transform(this.entity);
		on_added();
	}

	public function update(e:Float)
	{
		
	}

	public function on_added()
	{

	}

	public function on_remove()
	{

	}

}

class Transform
{

	var e:Entity;

	@:isVar public var x(get, set):Float;
	function get_x() { return e.pos.x; }
	function set_x(x) { return e.pos.x = x; }

	@:isVar public var y(get, set):Float;
	function get_y() { return e.pos.y; }
	function set_y(y) { return e.pos.y = y; }

	@:isVar public var angle(get, set):Float;
	function get_angle() { return e.angle; }
	function set_angle(a) { return e.angle = a; }

	public var scale:TVec;
	public var velocity:TVec;
	public var acceleration:TVec;

	public function new(e:Entity)
	{
		this.e = e;
		scale = new TVec(e.scale);
		velocity = new TVec(e.velocity);
		acceleration = new TVec(e.acceleration);
	}

	public function set_position(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}

}

class TVec
{

	var o:Dynamic;
	@:isVar var x(get, set):Float;
	function get_x() { return o.x; }
	function set_x(x) { return o.x = x; }

	@:isVar var y(get, set):Float;
	function get_y() { return o.y; }
	function set_y(y) { return o.y = y; }
	
	public function new(object:Dynamic) { o = object; }
	
	public function set(x:Float = 0, ?y:Float)
	{
		if (y == null) y = x;
		this.x = x;
		this.y = y;
	}

	public function to_point():FlxPoint { return FlxPoint.get(x, y); }
	public function from_point(p:FlxPoint) { set(p.x, p.y); }

}