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

    public function new(mouse_visible:Bool = false, esc_exits:Bool = false)
    {
        FlxG.mouse.visible = mouse_visible;
        this.esc_exits = esc_exits;
        super();
    }

    override public function update(e)
    {
        super.update(e);
		if (esc_exits) check_esc();
    }

	function check_esc()
	{
		#if cpp
		if (FlxG.keys.justPressed.ESCAPE) lime.system.System.exit(0);
		#end
	}

}