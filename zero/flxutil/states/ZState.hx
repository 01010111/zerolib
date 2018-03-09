package zero.flxutil.states;

import flixel.FlxG;
import flixel.FlxState;

/**
 *  @author 01010111 
 */
class ZState extends FlxState
{

    var esc_exits:Bool;
    var check_fullscreen:Bool;

    public function new(mouse_visible:Bool = false, check_fullscreen:Bool = true, esc_exits:Bool = false)
    {
        FlxG.mouse.visible = mouse_visible;
        this.esc_exits = esc_exits;
        this.check_fullscreen = check_fullscreen;
        super();
    }

    override public function update(e)
    {
        super.update(e);
        fullscreen_check();
    }

    function fullscreen_check()
    {
        #if !web
        if (!check_fullscreen) return;
        if (FlxG.keys.justPressed.ENTER && FlxG.keys.pressed.ALT) FlxG.fullscreen = !FlxG.fullscreen;
        #end
    }

}