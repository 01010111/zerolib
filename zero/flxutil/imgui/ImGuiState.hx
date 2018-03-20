package zero.flxutil.imgui;

import imgui.ImGui;
import flixel.FlxState;

class ImGuiState extends FlxState
{

	override public function create()
	{
		super.create();
		FlxImGui.init();
	}

	override public function update(elapsed:Float):Void
	{
		FlxImGui.newFrame();
		super.update(elapsed);
		FlxImGui.render();
	}
}
