package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;
import zero.util.Vector;

class IsOnCircle extends Component
{

	var p:Vector;
	public var center:Vector;
	public var angle:Float;
	public var radius:Float;
	public var update_angle:Bool;

	public function new(center:Vector, angle:Float, radius:Float, update_angle:Bool = true)
	{
		this.center = center;
		this.angle = angle;
		this.radius = radius;
		this.update_angle = update_angle;
		this.p = new Vector().copy_from(center);
		super('is on circle', ['transform']);
	}

	override public function update(e:Float)
	{
		p.angle = angle;
		p.len = radius;
		transform.set_position(center.x + p.x, center.y + p.y);
		if (update_angle) transform.angle = angle;
		super.update(e);
	}

}