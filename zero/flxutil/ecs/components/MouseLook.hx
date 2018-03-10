package zero.flxutil.ecs.components;

import flixel.FlxG;
import zero.util.Vector;

class MouseLook extends TargetLook
{

	public function new()
	{
		super();
		id = 'mouse look';
		tags.push('mouse');
	}

	override function get_angle_to_target():Float
	{
		return new Vector(FlxG.mouse.x - entity.x, FlxG.mouse.y - entity.y).angle;
	}

}