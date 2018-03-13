package zero.flxutil.ecs;

import flixel.math.FlxPoint;
import zero.flxutil.ecs.Entity;

using zero.ext.StringExt;

/**
 *  @author 01010111
 *  changing transform changes the component's entity's transform as well!
 */
class Component
{

	var id:String;
	var tags:Array<String> = [];
	var entity:Entity;
	var transform:Transform;

	/**
	 *  Creates a new component with an id and tags. A random string will be created for a blank id.
	 *  @param id - 
	 *  @param tags - 
	 */
	public function new(id:String = '', ?tags:Array<String>)
	{
		this.id = id.length == 0 ? id.get_random(64, 'C_${Type.getClassName(Type.getClass(this))}_') : id;
		this.tags = tags == null ? [] : tags;
	}

	/**
	 *  returns the id of this component
	 *  @return String
	 */
	public function get_id():String
	{
		return id;
	}

	/**
	 *  returns whether or not this component contains a tag
	 *  @param tag - 
	 *  @return Bool
	 */
	public function has_tag(tag:String):Bool
	{
		for (t in tags) if (t == tag) return true;
		return false;
	}

	/**
	 *  adds this component to an entity, automatically called in Entity.add_component()
	 *  @param entity - 
	 */
	public function add_to(entity:Entity)
	{
		this.entity = entity;
		transform = new Transform(this.entity);
		on_added();
	}

	/**
	 *  runs once a frame, override to use!
	 *  @param e - 
	 */
	public function update(e:Float)
	{
		
	}

	/**
	 *  automatically called in add_to()
	 */
	public function on_added()
	{

	}

	/**
	 *  automatically called in Entity.remove_component()
	 */
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
	@:isVar public var x(get, set):Float;
	function get_x() { return o.x; }
	function set_x(x) { return o.x = x; }

	@:isVar public var y(get, set):Float;
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