package zero.flxutil.ecs;

import flixel.math.FlxPoint;

class Component
{

	var entity:Entity;
	var name:String;

	public var x(get,set):Float;
	function get_x():Float return entity.x;
	function set_x(v:Float):Float return entity.x = v;

	public var y(get,set):Float;
	function get_y():Float return entity.y;
	function set_y(v:Float):Float return entity.y = v;

	public var angle(get,set):Float;
	function get_angle():Float return entity.angle;
	function set_angle(v:Float):Float return entity.angle = v;

	public var velocity:FlxPoint;
	public var acceleration:FlxPoint;
	public var drag:FlxPoint;
	public var scale:FlxPoint;

	public function new(name:String) this.name = name;
	public function get_name():String return name;

	public function add_to(entity:Entity)
	{
		this.entity = entity;

		velocity = entity.velocity;
		acceleration = entity.acceleration;
		drag = entity.drag;
		scale = entity.scale;

		on_add();
	}

	public function update(dt:Float) {}
	public function on_add() {}
	public function on_remove() {}

}