package zero.flxutil.imgui;

import imgui.ImGui;
import flixel.FlxBasic;

class ImGuiWindow extends FlxBasic
{

	var window_title:String;

	public function new(title:String)
	{
		super();
		window_title = title;
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		ImGui.begin(window_title);
		window();
		ImGui.end();
	}

	function window()
	{
		ImGui.text('no content!');
	}

}