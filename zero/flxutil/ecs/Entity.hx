package zero.flxutil.ecs;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import zero.flxutil.ecs.Component;
import zero.flxutil.ecs.State;
import zero.util.IntPoint;
import zero.util.Vector;

class Entity extends FlxSprite
{

	var id:String;
	var tags:Array<String> = [];
	var components:Array<Component> = [];
	
	public var pos:Vector;
	public var update_position:Void -> Void;

	public function new(id:String, options:EntityOptions)
	{
		this.id = id;
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

	public function get_id():String
	{
		return id;
	}

	public function has_tag(tag:String):Bool
	{
		for (t in tags) if (t == tag) return true;
		return false;
	}

	public function add_component(component:Component)
	{
		components.push(component);
		component.add_to(this);
	}

	public function remove_component(component:Component)
	{
		component.on_remove();
		components.remove(component);
	}

	public function get_component_by_id(id:String):Component
	{
		for (c in components) if (c.get_id() == id) return c;
		return null;
	}

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

}

typedef EntityOptions = {
	?position: Vector,
	?graphic: String,
	?frame_size: IntPoint,
	?components: Array<Component>
}