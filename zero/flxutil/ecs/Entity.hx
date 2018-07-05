package zero.flxutil.ecs;

import flixel.FlxSprite;

class Entity extends FlxSprite
{

	var components:Map<String, Component> = new Map();
	var tags:Array<String> = [];
	var name:String = 'Unknown';

	public function new(options:EntityOptions)
	{
		super(options.x, options.y);
		name = options.name;
		if (options.components == null) return;
		for (c in options.components) add_component(c);
	}

	public function add_component(component:Component)
	{
		if (components.exists(component.get_name())) trace('Component with name: ${component.get_name()} already exists!');
		else components.set(component.get_name(), component);
		component.add_to(this);
	}

	public function remove_component(name:String)
	{
		if (!components.exists(name))
		{
			trace('No components with name: $name exist!');
			return;
		}
		components[name].on_remove();
		components.remove(name);
	}

	public function get_component(name:String):Null<Component>
	{
		if (!components.exists(name)) trace('No components with name: $name exist!');
		return components[name];
	}

	public function add_tag(tag:String)
	{
		if (tags.indexOf(tag) >= 0) trace('tag: $tag already exists!');
		else tags.push(tag);
	}

	public inline function has_tag(tag:String):Bool return tags.indexOf(tag) >= 0;
	public inline function get_name():String return name;

	override public function update(dt:Float)
	{
		for (c in components) c.update(dt);
		super.update(dt);
	}

}

typedef EntityOptions =
{
	x:Float,
	y:Float,
	name:String,
	?components:Array<Component>,
}