package zero.flxutil.ecs;

import flixel.FlxSprite;

/**
 *  An Entity class for some light-weight ECS behavior in Flixel
 */
class Entity extends FlxSprite
{

	var components:Map<String, Component> = new Map();
	var tags:Array<String> = [];
	var name:String = 'Unknown';

	/**
	 *  Creates a new Entity with given options
	 *  @param options	EntityOptions - {
	 *  	x:Float							x position,
	 *  	y:Float							y position,
	 *  	name:String						Entity name,
	 *  	?components:Array<Component>	an array of components to be added to this Entity
	 *  }
	 */
	public function new(options:EntityOptions)
	{
		super(options.x, options.y);
		name = options.name;
		if (options.components == null) return;
		for (c in options.components) add_component(c);
	}

	/**
	 *  Add a component to this Entity
	 *  @param component	Component to be added to this entity
	 */
	public function add_component(component:Component)
	{
		if (components.exists(component.get_name())) trace('Component with name: ${component.get_name()} already exists!');
		else components.set(component.get_name(), component);
		component.add_to(this);
	}

	/**
	 *  Remove a component from this Entity
	 *  @param name	the component's name
	 */
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

	/**
	 *  Get component with name
	 *  @param name	component name
	 *  @return Null<Component>
	 */
	public function get_component(name:String):Null<Component>
	{
		if (!components.exists(name)) trace('No components with name: $name exist!');
		return components[name];
	}

	/**
	 *  Add tag to this Entity
	 *  @param tag	tag name
	 */
	public function add_tag(tag:String)
	{
		if (tags.indexOf(tag) >= 0) trace('tag: $tag already exists!');
		else tags.push(tag);
	}

	/**
	 *  Checks whether or not this Entity has a tag
	 *  @param tag	tag name
	 *  @return		Bool
	 */
	public inline function has_tag(tag:String):Bool return tags.indexOf(tag) >= 0;
	
	/**
	 *  returns the name of this Entity
	 *  @return	String
	 */
	public inline function get_name():String return name;

	@:dox(hide)
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