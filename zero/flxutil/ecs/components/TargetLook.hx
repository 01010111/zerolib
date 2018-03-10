package zero.flxutil.ecs.components;

import flixel.FlxG;
import flixel.FlxObject;
import zero.flxutil.ecs.Component;
import zero.util.Vector;

class TargetLook extends Component
{

	var target:FlxObject;

	public function new(?target:FlxObject)
	{
		if (target != null) this.target = target;
		super('target look', ['transform', 'target', 'constraint']);
	}

	override public function update(e:Float)
	{
		transform.angle = get_angle_to_target();
	}

	function get_angle_to_target():Float
	{
		if (target == null) return 0;
		return new Vector(target.getMidpoint().x - entity.x, target.getMidpoint().y - entity.y).angle;
	}

}