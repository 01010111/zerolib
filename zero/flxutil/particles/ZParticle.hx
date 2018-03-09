package zero.flxutil.particles;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 *  @author 01010111 
 */
class ZParticle extends FlxSprite
{

    public function new()
    {
        super();
        exists = false;
    }

    public function fire(p:FlxPoint, v:FlxPoint)
    {
        if (v == null) v = FlxPoint.get();
        reset(p.x, p.y);
        velocity.set(v.x, v.y);
    }

}