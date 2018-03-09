package zero.flxutil.ecs.components;

import flixel.FlxG;
import zero.flxutil.ecs.Component;
import zero.util.Vector;

class FacesMouse extends Component
{

	public function new()
	{
		super('faces mouse', ['transform', 'mouse']);
	}

	override public function update(e:Float)
	{
		transform.angle = get_angle_to_mouse();
	}

	public function get_angle_to_mouse():Float
	{
		return new Vector(FlxG.mouse.x - entity.x, FlxG.mouse.y - entity.y).angle;
	}

}