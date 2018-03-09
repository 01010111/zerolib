package zero.flxutil.states;

import flixel.FlxG;

/**
 *  @author 01010111 
 */
class ZPlayState extends ZState
{

    override public function update(e:Float)
    {
        super.update(e);

        #if debug
        if (FlxG.keys.justPressed.R && FlxG.keys.pressed.ALT) FlxG.resetState();
        #end
    }

}