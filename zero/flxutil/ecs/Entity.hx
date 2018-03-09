package zero.flxutil.ecs;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import zero.flxutil.ecs.Component;
import zero.flxutil.ecs.State;
import zero.util.IntPoint;
import zero.util.Vector;

using zero.ext.StringExt;

/**
 *  @author 01010111
 *  Update position with pos!
 */
class Entity extends FlxSprite
{

	var id:String;
	var tags:Array<String> = [];
	var components:Array<Component> = [];
	
	/**
	 *  use this to update position! pos.z is used for depth sorting!
	 */
	public var pos:Vector;

	/**
	 *  this sets x/y based on pos
	 */
	public var update_position:Void -> Void;

	/**
	 *  Creates a new Entity with id and options
	 *  @param id - 
	 *  @param options - 
	 */
	public function new(id:String = '', ?options:EntityOptions)
	{
		this.id = id.length == 0 ? id.get_random(64, 'E_${Type.getClassName(Type.getClass(this))}_') : id;
		if (options == null) options = {};
		update_position = update_pos;
		super();
		pos = options.position != null ? options.position : new Vector();
		if (options.components != null) components = options.components.copy();
		if (options.graphic != null)
		{
			if (options.frame_size != null) loadGraphic(options.graphic, true, options.frame_size.x, options.frame_size.y);
			else loadGraphic(options.graphic);
		}
		State.i.add_entity(this);
	}

	/**
	 *  returns the id of this entity
	 *  @return String
	 */
	public function get_id():String
	{
		return id;
	}

	/**
	 *  returns whether or not this entity has a tag
	 *  
	 *  @param   tag 
	 *  @return  Bool
	 */
	public function has_tag(tag:String):Bool
	{
		for (t in tags) if (t == tag) return true;
		return false;
	}

	/**
	 *  Adds a component to this entity
	 *  
	 *  @param   component 
	 */
	public function add_component(component:Component)
	{
		components.push(component);
		component.add_to(this);
	}

	/**
	 *  removes a component from this entity
	 *  
	 *  @param   component 
	 */
	public function remove_component(component:Component)
	{
		if (component == null) return;
		component.on_remove();
		components.remove(component);
	}

	/**
	 *  returns a component with an id
	 *  
	 *  @param   id 
	 *  @return  Component
	 */
	public function get_component_by_id(id:String):Component
	{
		for (c in components) if (c.get_id() == id) return c;
		return null;
	}

	/**
	 *  returns an array of components with a tag
	 *  
	 *  @param   tag 
	 *  @return  Array<Component>
	 */
	public function get_components_by_tag(tag:String):Array<Component>
	{
		return [for (c in components) if (c.has_tag(tag)) c];
	}

	override public function update(e:Float)
	{
		for (component in components) component.update(e);
		update_position();
		super.update(e);
	}

	function update_pos()
	{
		setPosition(pos.x, pos.y);
	}

	public function on_added()
	{

	}

}

typedef EntityOptions = {
	?position: Vector,
	?graphic: String,
	?frame_size: IntPoint,
	?components: Array<Component>
}