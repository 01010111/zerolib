package zero.flxutil.particles;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Particle extends FlxSprite
{

    public function new()
    {
        super(FlxPoint.get());
        exists = false;
    }

    public function fire(p:FlxPoint, v:FlxPoint)
    {
        if (v == null) v = FlxPoint.get();
        reset(p.x, p.y);
        velocity.set(v.x, v.y);
    }

}