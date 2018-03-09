package zero.flxutil.ecs;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import zero.flxutil.ecs.Entity;

/**
 *  @author 01010111
 *  make sure you run super.create()!
 */
class State extends FlxState
{

	public static var i:State;
	var entities:FlxTypedGroup<Entity>;

	public function new()
	{
		super();
		i = this;
		entities = new FlxTypedGroup();
	}

	override public function create()
	{
		add(entities);
	}

	public function add_entity(e:Entity)
	{
		entities.add(e);
		e.on_added();
	}

	override public function update(e:Float)
	{
		entities.sort(function(d:Int, e1:Entity, e2:Entity):Int {
			if (e1.pos.z > e2.pos.z) return 1;
			if (e1.pos.z < e2.pos.z) return -1;
			return 0;
		}, 1);
		super.update(e);
	}

	public function get_entity_by_id(id:String):Entity
	{
		for (e in entities) if (e.id == id) return e;
		return null;
	}

	public function get_entities_by_tag(tag:String):Array<Entity>
	{
		return [for (e in entities) if (e.has_tag(tag)) e];
	}

}