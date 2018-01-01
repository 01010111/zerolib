package zero.flxutil.particles;

import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.particles.bases.Particle;

class ParticleGroup<T:Particle> extends FlxTypedGroup<T>
{

    public var add_obj:Void -> Void;

    public function new(add_obj:Void -> Void)
    {
        super();
        this.add_obj = add_obj;
        add_obj();
    }

    function get_obj():Particle
    {
        if (getFirstAvailable() != null) return getFirstAvailable();
        else 
        {
            add_obj();
            return getFirstAvailable();
        }
    }

    public function fire(_position:FlxPoint, _velocity:FlxPoint = null)
    {
        get_obj().fire(_position, _velocity);
    }

}