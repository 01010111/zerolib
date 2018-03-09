package zero.flxutil.ecs;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import zero.flxutil.ecs.Entity;

class State extends FlxState
{

	public static var i:State;
	var entities:FlxTypedGroup<Entity>;

	public function new()
	{
		super();
		i = this;
	}

	override public function create()
	{
		entities = new FlxTypedGroup();
		add(entities);
	}

	public function add_entity(e:Entity)
	{
		entities.add(e);
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

}