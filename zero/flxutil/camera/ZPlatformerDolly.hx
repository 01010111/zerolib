package zero.flxutil.camera;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;
using Math;

/**
 * Thanks to Itay Keren and his amazing talk "Scroll Back: The Theory and Practice of Cameras in Side-Scrollers"
 *  
 * @author 01010111
 */
class ZPlatformerDolly extends FlxObject
{
	
	var target:FlxSprite;
	var opt:DollyOptions;
	var temp_pos:FlxPoint;
	var facing:Float;
	var debug_sprite:FlxSprite;
	
	public function new(target:FlxSprite, options:DollyOptions) 
	{
		temp_pos = FlxPoint.get();

		if (options.lerp == null) options.lerp = FlxPoint.get(1, 1);

		opt = options;
		super(0, 0, options.window_size.x, options.window_size.y);

		switch_target(target, true);

		FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
		FlxG.camera.deadzone.set((FlxG.width - width).half(), (FlxG.height - height).half(), width, height);
		FlxG.state.add(this);
	}

	public function get_debug_sprite():FlxSprite
	{
		var draw_dotted_line = function(sprite:FlxSprite, p1:FlxPoint, p2:FlxPoint, segments:Int, color:Int = 0xFFFFFFFF, thickness:Int = 1) {
			segments = segments * 2 + 1;
			var len = p1.distance(p2);
			for (s in 0...segments)
			{
				if (s % 2 != 0) continue;
				var tp1 = p1.get_point_between(p2, s / segments);
				var tp2 = p1.get_point_between(p2, (s + 1) / segments);
				FlxSpriteUtil.drawLine(sprite, tp1.x, tp1.y, tp2.x, tp2.y, { thickness: thickness, color: color }); 
			}
		}

		debug_sprite = new FlxSprite();
		debug_sprite.makeGraphic(width.to_int(), height.to_int(), 0x00FFFFFF);
		draw_dotted_line(debug_sprite, FlxPoint.get(), FlxPoint.get(debug_sprite.width - 1, 0), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(debug_sprite.width - 1, 0), FlxPoint.get(debug_sprite.width, debug_sprite.height - 1), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(debug_sprite.width - 1, debug_sprite.height - 1), FlxPoint.get(0, debug_sprite.height - 1), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(0, debug_sprite.height - 1), FlxPoint.get(0, 0), 16, 0xFFFF0000, 2);

		if (opt.platform_snapping != null)
		{
			var line_y = height.half() + opt.platform_snapping.platform_offset;
			FlxSpriteUtil.drawLine(debug_sprite, 0, line_y, width, line_y, { thickness: 1, color: 0xFFFFFFFF });
		}

		if (opt.forward_focus != null)
		{
			var draw_triangle = function(sprite:FlxSprite, p:FlxPoint, d:Int, size:Float = 5) {
				FlxSpriteUtil.drawPolygon(
					sprite, 
					[
						FlxPoint.get(p.x, p.y),
						FlxPoint.get(p.x + size * d, p.y + size.half()),
						FlxPoint.get(p.x, p.y + size),
					], 
					0xFFFFFFFF
				);
			}

			FlxSpriteUtil.drawLine(
				debug_sprite, 
				width.half() - opt.forward_focus.offset, 
				16, 
				width.half() - opt.forward_focus.offset, 
				height, 
				{ thickness: 1, color: 0xFFFFFFFF }
			);
			FlxSpriteUtil.drawLine(
				debug_sprite, 
				width.half() + opt.forward_focus.offset, 
				16, 
				width.half() + opt.forward_focus.offset, 
				height, 
				{ thickness: 1, color: 0xFFFFFFFF }
			);
			draw_triangle(debug_sprite, FlxPoint.get(width.half() - opt.forward_focus.offset, 16), 1);
			draw_triangle(debug_sprite, FlxPoint.get(width.half() + opt.forward_focus.offset, 16), -1);

			if (opt.forward_focus.trigger_offset > 0)
			{
				draw_dotted_line(
					debug_sprite, 
					FlxPoint.get(width.half() - opt.forward_focus.trigger_offset, 24), 
					FlxPoint.get(width.half() - opt.forward_focus.trigger_offset, height - 16),
					12 
				);
				draw_dotted_line(
					debug_sprite, 
					FlxPoint.get(width.half() + opt.forward_focus.trigger_offset, 24), 
					FlxPoint.get(width.half() + opt.forward_focus.trigger_offset, height - 16),
					12 
				);
				draw_triangle(debug_sprite, FlxPoint.get(width.half() - opt.forward_focus.trigger_offset, 24), -1);
				draw_triangle(debug_sprite, FlxPoint.get(width.half() + opt.forward_focus.trigger_offset, 24), 1);
			}
		}

		return debug_sprite;
	}

	public function focus(position:FlxPoint)
	{
		x = position.x - width.half();
		y = position.y - height.half();
	}
		
	public function switch_target(target:FlxSprite, snap:Bool = false):Void
	{
		this.target = target;
		facing = target.facing;
		if (snap) focus(target.getMidpoint());
	}
	
	override public function update(elapsed:Float):Void 
	{
		var update_pos = {
			x: target.x < x || target.x + target.width > x + width,
			y: target.y < y || target.y + target.height > y + height
		};

		if (opt.platform_snapping != null) platform_snapping();
		if (opt.forward_focus != null) forward_focus(target.getMidpoint().x - getMidpoint().x);

		if (update_pos.x)
		{
			var ox = target.x < x ? target.x - x : (target.x + target.width) - (x + width);
			ox *= 1.5;
			x += ox * opt.lerp.x;
		}
		if (update_pos.y)
		{
			var oy = target.y < y ? target.y - y : (target.y + target.height) - (y + height);
			oy *= 1.5;
			y += oy * opt.lerp.y;
		}

		if (debug_sprite != null) debug_sprite.setPosition(x, y);

		super.update(elapsed);
	}

	function platform_snapping()
	{
		if (target.isTouching(FlxObject.FLOOR)) temp_pos.y = target.y + target.height;

		var offset = temp_pos.y - (y + height * 0.5 + opt.platform_snapping.platform_offset);

		if (opt.platform_snapping.max_delta != null) 
		{
			offset.clamp(-opt.platform_snapping.max_delta, opt.platform_snapping.max_delta);
		}

		var lerp = 1.0;
		if (opt.platform_snapping.lerp > 0) lerp = opt.platform_snapping.lerp;
		else if (opt.lerp != null) lerp = opt.lerp.y;
		var max = opt.platform_snapping.max_delta > 0 ? opt.platform_snapping.max_delta : 999;
		y += (offset * lerp).clamp(-max, max);
	}

	function forward_focus(offset:Float)
	{
		if (facing != target.facing)
		{
			if (opt.forward_focus.trigger_offset != null)
			{
				if (offset.abs() > opt.forward_focus.trigger_offset) facing = target.facing;
			}
			else facing = target.facing;
		}
		else
		{
			var d = facing == FlxObject.LEFT ? 1 : -1;
			offset -= opt.forward_focus.offset * d;
			var max = opt.forward_focus.max_delta > 0 ? opt.forward_focus.max_delta : 999;
			x += (offset * 0.1).clamp(-max, max);
		}
	}
	
}

typedef DollyOptions = {
	window_size:FlxPoint,
	?lerp:FlxPoint,
	?platform_snapping:PlatformSnapOptions,
	?forward_focus:ForwardFocusOptions
}

typedef PlatformSnapOptions = {
	platform_offset:Float,
	?lerp:Float,
	?max_delta:Float
}

typedef ForwardFocusOptions = {
	offset:Float,
	?trigger_offset:Float,
	?lerp:Float,
	?max_delta:Float
}