package zero.flxutil.ecs;

import flixel.math.FlxPoint;

/**
 *  A Component class to be added to an Entity.
 */
class Component
{

	var entity:Entity;
	var name:String;
	var tags:Array<String>;

	@:dox(hide)
	public var x(get,set):Float;
	function get_x():Float return entity.x;
	function set_x(v:Float):Float return entity.x = v;

	@:dox(hide)
	public var y(get,set):Float;
	function get_y():Float return entity.y;
	function set_y(v:Float):Float return entity.y = v;

	@:dox(hide)
	public var angle(get,set):Float;
	function get_angle():Float return entity.angle;
	function set_angle(v:Float):Float return entity.angle = v;

	@:dox(hide) public var velocity:FlxPoint;
	@:dox(hide) public var acceleration:FlxPoint;
	@:dox(hide) public var drag:FlxPoint;
	@:dox(hide) public var scale:FlxPoint;

	/**
	 *  Creates a new Component with given name
	 *  @param name	a name for this component
	 */
	public function new(name:String, ?tags:Array<String>)
	{
		this.name = name;
		this.tags = tags == null ? [] : tags;
	}

	/**
	 *  returns the name of this component
	 */
	public function get_name():String return name;

	/**
	 * Returns whether or not this component is tagged with given tag
	 * @param tag 
	 * @return Bool return tags.indexOf(tag) >= 0
	 */
	public function has_tag(tag:String):Bool return tags.indexOf(tag) >= 0;

	@:dox(hide)
	public function add_to(entity:Entity)
	{
		this.entity = entity;

		velocity = entity.velocity;
		acceleration = entity.acceleration;
		drag = entity.drag;
		scale = entity.scale;

		on_add();
	}

	@:dox(hide) public function update(dt:Float) {}

	/**
	 *  Called when added to an entity
	 */
	public function on_add() {}

	/**
	 *  Called when removed from an entity
	 */
	public function on_remove() {}

}