package zero.flxutil.imgui;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.events.KeyboardEvent;
import openfl.display.BitmapData;

import imgui.ImGui;
import imgui.util.ImVec2;
import imgui.draw.ImDrawData;

import cpp.Pointer;
import cpp.RawPointer;
import cpp.Callable;

class FlxImGui
{
	private static var atlas : FlxSprite;
	private static var group : FlxSpriteGroup;
	private static var state : FlxState;

	public static function init()
	{
		group = new FlxSpriteGroup();
		state = FlxG.state;

		var io = ImGui.getIO();
		io.renderDrawListsFn  = Callable.fromStaticFunction(drawImGuiRaw);
		io.getClipboardTextFn = Callable.fromStaticFunction(getClipboard);
		io.setClipboardTextFn = Callable.fromStaticFunction(setClipboard);

		io.keyMap[ImGuiKey.Tab			] = FlxKey.TAB;
		io.keyMap[ImGuiKey.LeftArrow	] = FlxKey.LEFT;
		io.keyMap[ImGuiKey.RightArrow	] = FlxKey.RIGHT;
		io.keyMap[ImGuiKey.UpArrow		] = FlxKey.UP;
		io.keyMap[ImGuiKey.DownArrow	] = FlxKey.DOWN;
		io.keyMap[ImGuiKey.PageUp		] = FlxKey.PAGEUP;
		io.keyMap[ImGuiKey.PageDown		] = FlxKey.PAGEDOWN;
		io.keyMap[ImGuiKey.Home			] = FlxKey.HOME;
		io.keyMap[ImGuiKey.End			] = FlxKey.END;
		io.keyMap[ImGuiKey.Delete		] = FlxKey.DELETE;
		io.keyMap[ImGuiKey.Backspace	] = FlxKey.BACKSPACE;
		io.keyMap[ImGuiKey.Enter		] = FlxKey.ENTER;
		io.keyMap[ImGuiKey.Escape		] = FlxKey.ESCAPE;
		io.keyMap[ImGuiKey.A			] = FlxKey.A;
		io.keyMap[ImGuiKey.C			] = FlxKey.C;
		io.keyMap[ImGuiKey.V			] = FlxKey.V;
		io.keyMap[ImGuiKey.X			] = FlxKey.X;
		io.keyMap[ImGuiKey.Y			] = FlxKey.Y;
		io.keyMap[ImGuiKey.Z			] = FlxKey.Z;

		// Get the array of bytes of the ImGui Atlas
		var fontAtlas = Pointer.fromRaw(io.fonts).ref;
		var width  = 0;
		var height = 0;
		var pixels : Array<Int> = null;
		fontAtlas.getTexDataAsRGBA32(pixels, width, height);

		// Convert pixels from RGBA to ARGB
		var it : Int = cast pixels.length / 4;
		for (i in 0...it)
		{
			var baseIdx = (i * 4);
			var newA = pixels[baseIdx + 3];
			pixels[baseIdx + 3] = pixels[baseIdx];
			pixels[baseIdx] = newA;
		}

		// Create BitmapData for the ImGui Atlas
		var bitmap = new BitmapData(width, height);
		bitmap.setPixels(new Rectangle(0, 0, width, height), ByteArray.fromBytes(haxe.io.Bytes.ofData(cast pixels)));
		atlas = new FlxSprite(0, 0, bitmap);

		// Create a pointer of the atlas.
		fontAtlas.texID = Pointer.addressOf(atlas).rawCast();

		// Listen for keyboard events
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	public static function newFrame(?_state : FlxState)
	{
		if (_state != null) state = _state;

		var io = ImGui.getIO();
		io.displaySize	= ImVec2.create(FlxG.width, FlxG.height);
		io.mousePos.x	= FlxG.mouse.x;
		io.mousePos.y	= FlxG.mouse.y;
		io.mouseDown[0]	= FlxG.mouse.pressed;
		io.mouseDown[1]	= FlxG.mouse.pressedRight;
		io.mouseWheel	= FlxG.mouse.wheel;
		io.keyCtrl		= FlxG.keys.pressed.CONTROL;
		io.keyAlt		= FlxG.keys.pressed.ALT;
		io.keyShift		= FlxG.keys.pressed.SHIFT;

		io.keysDown[FlxKey.TAB		] = FlxG.keys.pressed.TAB;
		io.keysDown[FlxKey.LEFT		] = FlxG.keys.pressed.LEFT;
		io.keysDown[FlxKey.RIGHT	] = FlxG.keys.pressed.RIGHT;
		io.keysDown[FlxKey.UP		] = FlxG.keys.pressed.UP;
		io.keysDown[FlxKey.DOWN		] = FlxG.keys.pressed.DOWN;
		io.keysDown[FlxKey.PAGEUP	] = FlxG.keys.pressed.PAGEUP;
		io.keysDown[FlxKey.PAGEDOWN	] = FlxG.keys.pressed.PAGEDOWN;
		io.keysDown[FlxKey.HOME		] = FlxG.keys.pressed.HOME;
		io.keysDown[FlxKey.END		] = FlxG.keys.pressed.END;
		io.keysDown[FlxKey.ENTER	] = FlxG.keys.pressed.ENTER;
		io.keysDown[FlxKey.BACKSPACE] = FlxG.keys.pressed.BACKSPACE;
		io.keysDown[FlxKey.ESCAPE	] = FlxG.keys.pressed.ESCAPE;
		io.keysDown[FlxKey.DELETE	] = FlxG.keys.pressed.DELETE;
		io.keysDown[FlxKey.A		] = FlxG.keys.pressed.A;
		io.keysDown[FlxKey.C		] = FlxG.keys.pressed.C;
		io.keysDown[FlxKey.V		] = FlxG.keys.pressed.V;
		io.keysDown[FlxKey.X		] = FlxG.keys.pressed.X;
		io.keysDown[FlxKey.Y		] = FlxG.keys.pressed.Y;
		io.keysDown[FlxKey.Z		] = FlxG.keys.pressed.Z;

		ImGui.newFrame();
	}

	public static function render()
	{
		ImGui.render();
	}

	public static function clean()
	{
		atlas.destroy();
		group.destroy();
		state = null;

		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	//

	private static function onKeyDown(_event : KeyboardEvent)
	{
		if (_event.charCode != 0)
		{
			var io = ImGui.getIO();
			io.addInputCharactersUTF8(String.fromCharCode(_event.charCode));
		}
	}
	private static function intToColor(_int : Int) : FlxColor
	{
		var r = (_int)			& 0xFF;
		var g = (_int >> 8)		& 0xFF;
		var b = (_int >> 16)	& 0xFF;
		var a = (_int >> 24)	& 0xFF;

		return FlxColor.fromRGB(r, g, b, a);
	}
	static function getClipboard(_data : cpp.RawPointer<cpp.Void>) : cpp.ConstCharStar
	{
		return '';
	}
	static function setClipboard(_data : cpp.RawPointer<cpp.Void>, _text : cpp.ConstCharStar) : Void
	{
		//
	}
	private static function drawImGuiRaw(_drawRawPtr : cpp.RawPointer<ImDrawData>) : Void
	{
		group.destroy();
		group = new FlxSpriteGroup();

		var drawData = Pointer.fromRaw(_drawRawPtr).ref;
		for (i in 0...drawData.cmdListsCount)
		{
			var idxOffset = 0;
			var cmdList   = Pointer.fromRaw(drawData.cmdLists[i]).ref;
			var cmdBuffer = cmdList.cmdBuffer.data;
			var vtxBuffer = cmdList.vtxBuffer.data;
			var idxBuffer = cmdList.idxBuffer.data;

			for (j in 0...cmdList.cmdBuffer.size)
			{
				var cmd = cmdBuffer[j];
				var tex : Pointer<FlxSprite> = Pointer.fromRaw(cmd.textureID).reinterpret();

				var stripIdx = 0;
				var strip = new FlxStrip();
				strip.loadGraphicFromSprite(tex.ref);

				strip.vertices = new openfl.Vector<Float>();
				strip.uvtData  = new openfl.Vector<Float>();
				strip.indices  = new openfl.Vector<Int>();
				strip.colors   = new openfl.Vector<Int>();

				var it : Int = cast cmd.elemCount / 3;
				for (tri in 0...it)
				{
					var baseIdx = idxOffset + (tri * 3);
					var idx1 = idxBuffer[baseIdx + 0];
					var idx2 = idxBuffer[baseIdx + 1];
					var idx3 = idxBuffer[baseIdx + 2];
					var vtx1 = vtxBuffer[idx1];
					var vtx2 = vtxBuffer[idx2];
					var vtx3 = vtxBuffer[idx3];

					strip.colors.push(intToColor(vtx1.col));
					strip.colors.push(intToColor(vtx2.col));
					strip.colors.push(intToColor(vtx3.col));

					strip.uvtData.push(vtx1.uv.x);
					strip.uvtData.push(vtx1.uv.y);
					strip.uvtData.push(vtx2.uv.x);
					strip.uvtData.push(vtx2.uv.y);
					strip.uvtData.push(vtx3.uv.x);
					strip.uvtData.push(vtx3.uv.y);

					strip.vertices.push(vtx1.pos.x);
					strip.vertices.push(vtx1.pos.y);
					strip.indices.push(stripIdx++);

					strip.vertices.push(vtx2.pos.x);
					strip.vertices.push(vtx2.pos.y);
					strip.indices.push(stripIdx++);

					strip.vertices.push(vtx3.pos.x);
					strip.vertices.push(vtx3.pos.y);
					strip.indices.push(stripIdx++);
				}

				strip.clipRect = FlxRect.get(cmd.clipRect.x, cmd.clipRect.y, cmd.clipRect.z - cmd.clipRect.x, cmd.clipRect.w - cmd.clipRect.y);
				group.add(strip);

				idxOffset += cmd.elemCount;
			}
		}

		state.add(group);
	}
}