package zero.flxutil.camera;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;

using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;
using Math;

/**
 * A Handy Platformer camera dolly with several advanced features
 * Thanks to Itay Keren and his amazing GDC talk "Scroll Back: The Theory and Practice of Cameras in Side-Scrollers"
 */
class PlatformerDolly extends FlxObject
{
	// required vars
	var target:FlxSprite;
	var opt:DollyOptions;

	// platform snapping
	var plat_y:Float;

	// forward focus
	var facing:Float;

	// debug
	var show_debug:Bool = false;
	var debug_sprite:FlxSprite;
	
	/**
	 *  Creates a dolly with configurable platforming specific behavior, and adds it to the current state.
	 *  @param   target the target to follow
	 *  @param   options configuration for dolly
	 *  
	 *  options object (*required)
	 *  {
	 *  	*window_size: FlxPoint (size of the dolly),
	 *  	lerp: FlxPoint (rate of change in position on two axes 0-1),
	 *  	platform_snapping: PlatformSnapOptions (options object for platform snapping) {
	 *  		*platform_offset: Float (target distance from center of dolly),
	 *  		lerp: Float (rate of change in position on y axis),
	 *  		max_delta: Float (maximum change in position)
	 *  	},
	 *  	forward_focus: ForwardFocusOptions (options object for forward focus) {
	 *  		*offset: Float (target distance from center of dolly),
	 *  		trigger_offset: Float (direction trigger distance from center of dolly),
	 *  		lerp: Float (rate of change in position on x axis),
	 *  		max_delta: Float (maximum change in position)
	 *  	},
	 *  	edge_snapping: EdgeSnapOptions (options object for edge snapping) {
	 *  		tilemap: FlxTilemap (tilemap to constrain the camera),
	 *  		rect: FlxRect (rectangle to constrain the camera)
	 *  	}
	 *  }
	 */
	public function new(?target:FlxSprite, options:DollyOptions) 
	{
		if (options.lerp == null) options.lerp = FlxPoint.get(1, 1);
		opt = options;

		super(0, 0, options.window_size.x, options.window_size.y);

		switch_target(target, true);
		configure_camera();

		FlxG.state.add(this);
	}

	function configure_camera()
	{
		FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
		FlxG.camera.deadzone.set((FlxG.width - width).half(), (FlxG.height - height).half(), width, height);
		if (opt.edge_snapping != null)
		{
			if (opt.edge_snapping.tilemap != null) opt.edge_snapping.tilemap.follow();
			else if (opt.edge_snapping.rect != null)
			{
				var r = opt.edge_snapping.rect;
				FlxG.camera.setScrollBoundsRect(r.x, r.y, r.width, r.height, true);
			}
		}
	}

	/**
	 *  Switches the camera target
	 *  @param target	the target to follow
	 *  @param snap		whether or not to snap to target immediately
	 */
	public function switch_target(?target:FlxSprite, snap:Bool = false):Void
	{
		this.target = target;
		if (target == null) return;
		facing = target.facing;
		if (snap) focus(target.getPosition().add(target.width.half(), target.height));
	}
	
	function focus(position:FlxPoint)
	{
		x = position.x - width.half();
		y = position.y - height.half();

		if (opt.platform_snapping != null) 
		{
			y -= (opt.platform_snapping.platform_offset - 1);
			plat_y = target.y + target.height;
		}
		if (opt.forward_focus != null) 
		{
			x += facing == FlxObject.LEFT 
				? -opt.forward_focus.offset
				: opt.forward_focus.offset;
		}
	}
	
	@:dox(hide)
	override public function update(dt:Float):Void 
	{
		if (target == null)
		{
			super.update(dt);
			return;
		}

		#if debug
		if (FlxG.keys.pressed.SHIFT)
		{
			manual_control();
			return;
		}
		#end

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

		if (show_debug) debug_sprite.setPosition(x, y);

		super.update(dt);
	}

	function manual_control()
	{
		if (FlxG.keys.pressed.UP) y--;
		if (FlxG.keys.pressed.DOWN) y++;
		if (FlxG.keys.pressed.LEFT) x--;
		if (FlxG.keys.pressed.RIGHT) x++;
	}

	function platform_snapping()
	{
		if (target.wasTouching & FlxObject.FLOOR > 0) plat_y = target.y + target.height;

		var offset = plat_y - (y + height * 0.5 + opt.platform_snapping.platform_offset);

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

	/**
	 *  Creates and returns a debug sprite that visualizes the dolly's configuration
	 *  @return	FlxSprite
	 */
	public function get_debug_sprite():FlxSprite
	{
		show_debug = true;

		debug_sprite = new FlxSprite();
		debug_sprite.makeGraphic(width.to_int(), height.to_int(), 0x00FFFFFF);

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

		draw_dotted_line(debug_sprite, FlxPoint.get(), FlxPoint.get(debug_sprite.width - 1, 0), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(debug_sprite.width - 1, 0), FlxPoint.get(debug_sprite.width, debug_sprite.height - 1), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(debug_sprite.width - 1, debug_sprite.height - 1), FlxPoint.get(0, debug_sprite.height - 1), 16, 0xFFFF0000, 2);
		draw_dotted_line(debug_sprite, FlxPoint.get(0, debug_sprite.height - 1), FlxPoint.get(0, 0), 16, 0xFFFF0000, 2);
		
		FlxSpriteUtil.drawLine(debug_sprite, width.half() - 8, height.half(), width.half() + 8, height.half(), { thickness: 1, color: 0xFFFF0000 });
		FlxSpriteUtil.drawLine(debug_sprite, width.half(), height.half() - 8, width.half(), height.half() + 8, { thickness: 1, color: 0xFFFF0000 });

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
	
}

typedef DollyOptions = {
	window_size:FlxPoint,
	?lerp:FlxPoint,
	?platform_snapping:PlatformSnapOptions,
	?forward_focus:ForwardFocusOptions,
	?edge_snapping:EdgeSnapOptions
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

typedef EdgeSnapOptions = {
	?tilemap:FlxTilemap,
	?rect:FlxRect
}