package zero.flxutil.ecs.components;

import zero.flxutil.ecs.Component;
import zero.util.Vector;

/**
 * Constrains an Entity to a circle
 */
class CircleConstraint extends Component
{

	var p:Vector;
	public var center:Vector;
	public var match_angle:Bool;

	/**
	 * Create a new constraint that will place an object on the given angle of a circle with a given radius
	 * @param center		the center point of the circle
	 * @param angle			the angle at which to place the entity
	 * @param radius		the radius of the circle
	 * @param match_angle	whether or not to update the entity's angle to match it's relation to the center
	 */
	public function new(center:Vector, angle:Float, radius:Float, match_angle:Bool = true)
	{
		this.match_angle = match_angle;
		this.center = center;
		this.p = new Vector().copy_from(center);
		update_position(angle, radius);
		super('circle_constraint');
	}

	@:dox(hide)
	override public function update(e:Float)
	{
		x = center.x + p.x - entity.width * 0.5;
		y = center.y + p.y - entity.height * 0.5;
		if (match_angle) angle = p.angle;
		super.update(e);
	}

	/**
	 * Update the position of the Entity using a given angle and radius
	 * @param angle 
	 * @param radius 
	 */
	public function update_position(angle:Float, radius:Float)
	{
		this.p.angle = angle;
		this.p.len = radius;
	}

	/**
	 * Update the position of the Entity using a given angle
	 * @param a	angle
	 */
	public inline function update_angle(a:Float) p.angle = a;

	/**
	 * Update the position of the Entity using a given radius
	 * @param r	radius
	 */
	public inline function update_radius(r:Float) p.len = r;

}