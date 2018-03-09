package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;
import zero.flxutil.ecs.Entity;
import zero.util.Vector;

class HasParent extends Component
{

	var parent:Entity;

	public function new(parent:Entity)
	{
		super('has parent', ['transform']);
		this.parent = parent;
	}

	override public function on_added()
	{
		entity.update_position = update_pos;
	}

	override public function update(e:Float)
	{
		super.update(e);
		transform.scale.from_point(parent.scale);
		transform.angle = parent.angle;
	}

	function update_pos()
	{
		var p = new Vector(transform.x * parent.scale.x, transform.y * parent.scale.y);
		p.angle += parent.angle;
		entity.setPosition(parent.x + p.x, parent.y + p.y);
	}

}