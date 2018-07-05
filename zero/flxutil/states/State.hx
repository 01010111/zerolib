package zero.flxutil.states;

import flixel.FlxG;
import flixel.FlxState;

/**
 *  @author 01010111 
 */
class State extends FlxState
{

	var esc_exits:Bool;

	public function new(mouse_visible:Bool = false, esc_exits:Bool = false)
	{
		#if !mobile FlxG.mouse.visible = mouse_visible; #end
		this.esc_exits = esc_exits;
		super();
	}

	override public function update(e)
	{
		super.update(e);
		check_reset();
		if (esc_exits) check_esc();
	}

	function check_esc() { #if (cpp && !mobile) if (FlxG.keys.justPressed.ESCAPE) lime.system.System.exit(0); #end }
	function check_reset() { #if (debug && !mobile) if (FlxG.keys.justPressed.R && FlxG.keys.pressed.ALT) FlxG.resetState(); #end }

}