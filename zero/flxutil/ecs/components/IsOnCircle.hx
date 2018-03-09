package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;
import flixel.math.FlxPoint;

using zero.ext.flx.FlxPointExt;

class IsOnCircle extends Component
{

	var p:Vector;
	var center:Vector;
	public var angle:Float;
	public var radius:Float;
	public var update_angle:Bool;

	public function new(center:Vector, angle:Float, radius:Float, update_angle:Bool = true)
	{
		this.center = center;
		this.angle = angle;
		this.radius = radius;
		this.update_angle = update_angle;
		this.p = new Vector().copyFrom(center);
		super('is on circle', ['transform']);
	}

	override public function update(e:Float)
	{
		p.copyFrom(center);
		p.angle = angle;
		p.radius = radius;
		transform.set_position(p.x, p.y);
		if (update_angle) transform.angle = angle;
		super.update(e);
	}

}