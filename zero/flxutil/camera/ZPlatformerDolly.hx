package zero.flxutil.camera;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;

using zero.ext.FloatExt;
using Math;

/**
 * I made this dolly to try and reflect the camera system in Super Mario World.
 * It features platform snapping, a camera window for deadzone, dual forward focus, and manual vertical control! 
 * thanks to Itay Keren and his amazing talk "Scroll Back: The Theory and Practice of Cameras in Side-Scrollers"
 * for making me realize I needed this in my platformers :P
 *  
 *  TODO: Needs review / update
 *  
 * @author 01010111
 */
class ZPlatformerDolly extends FlxObject
{
	
	var target:FlxSprite;
	var cam_offset:FlxPoint;
	var facing:Int;
	var should_move_y:Bool = false;
	var max_dolly_velocity:Int;
	var dolly_y_offset:Float;
	var look_down:Bool;
	var look_up:Bool;
	var should_center_target:Bool = false;
	
	/**
	 * A quick and easy dolly for a platformer camera. 
	 * @param	_target					FlxSprite to follow
	 * @param	_width_percent			Horizontal deadzone
	 * @param	_height_percent			Vertical deadzone
	 * @param	_max_dolly_velocity		Max. velocity in pixels per frame, smooths movement
	 * @param	_cam_offset				(optional) Leading offset (x) and vertical offset (y) 
	 * @param	_starting_pos_offset	(optional) Starting position offset
	 * @param	_camera_bounds			(optional) Set camera bounds to this FlxRect
	 */
	public function new(_target:FlxSprite, _width_percent:Float = 40, _height_percent:Float = 75, _max_dolly_velocity:Int = 3, ?_cam_offset:FlxPoint, ?_starting_pos_offset:FlxPoint, ?_camera_bounds:FlxRect ) 
	{
		super();
		
		switch_target(_target);
		
		if (_cam_offset != null)
			cam_offset = _cam_offset;
		else
			cam_offset = FlxPoint.get(target.width * 2, FlxG.height * 0.3 + target.height);
		
		if (_starting_pos_offset != null)
			setPosition(target.x - cam_offset.x + _starting_pos_offset.x, target.y - cam_offset.y + _starting_pos_offset.y);
		else
			setPosition(target.x - cam_offset.x, target.y - cam_offset.y);
		
		setSize(FlxG.width * (_width_percent / 100) - _target.width * 2, FlxG.height * (_height_percent / 100) - _target.height * 2);
		
		max_dolly_velocity = _max_dolly_velocity;
		
		FlxG.camera.targetOffset.y = -FlxG.height * 0.15;
		FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
		if (_camera_bounds != null)
			FlxG.camera.setScrollBoundsRect(_camera_bounds.x, _camera_bounds.y, _camera_bounds.width, _camera_bounds.height, true);
	}
	
	/**
	 * Manual vertical controls!
	 * @param	_up		Whether to pan the camera up...
	 * @param	_down	Whether to pan the camera down...
	 */
	public function vertical_look(_up:Bool = false, _down:Bool = false):Void
	{
		look_up = _up;
		look_down = _down;
	}
	
	/**
	 * Center the camera on the target. Useful for cutscenes perhaps?
	 */
	public function center_on_target():Void
	{
		should_center_target = true;
	}
	
	/**
	 * Switch the camera's target. Useful for cutscenes perhaps?
	 * @param	_target				FlxSprite for the camera to follow
	 * @param	_center_on_target	Whether or not to center the camera on target
	 */
	public function switch_target(_target:FlxSprite, _center_on_target:Bool = false):Void
	{
		target = _target;
		facing = _target.facing;
		if (_center_on_target) center_on_target();
	}
	
	public function make_overlay():FlxSprite
	{
		var _overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff, true);
		_overlay.scrollFactor.set();
		
		// Platform snapping
		var _p = Math.ceil((FlxG.height - height) * 0.5 + cam_offset.y + target.height) + 1;
		FlxSpriteUtil.drawLine(_overlay, FlxG.width * 0.2, _p, FlxG.width * 0.8, _p);
		
		// Left bound
		var _l_b = (FlxG.width - width) * 0.5 - target.width * 0.5;
		for (i in 0...Std.int((FlxG.height - 128) / 8))
			FlxSpriteUtil.drawLine(_overlay, _l_b, 64 + i * 8, _l_b, 64 + i * 8 + 4);
		FlxSpriteUtil.drawPolygon(_overlay, [FlxPoint.get(_l_b, 64 - 8), FlxPoint.get(_l_b - 8, 64 - 4), FlxPoint.get(_l_b, 64)]);
		
		// Right bound
		var _r_b = FlxG.width - (FlxG.width - width) * 0.5 + target.width * 0.5;
		for (i in 0...Std.int((FlxG.height - 128) / 8))
			FlxSpriteUtil.drawLine(_overlay, _r_b, 64 + i * 8, _r_b, 64 + i * 8 + 4);
		FlxSpriteUtil.drawPolygon(_overlay, [FlxPoint.get(_r_b, 64 - 8), FlxPoint.get(_r_b + 8, 64 - 4), FlxPoint.get(_r_b, 64)]);
		
		// Left snap
		var _l_s = _l_b + cam_offset.x + target.width * 0.5;
		FlxSpriteUtil.drawLine(_overlay, _l_s, 48, _l_s, FlxG.height - 48);
		FlxSpriteUtil.drawPolygon(_overlay, [FlxPoint.get(_l_s - 1, 48 - 8), FlxPoint.get(_l_s - 1 + 8, 48 - 4), FlxPoint.get(_l_s - 1, 48)]);
		
		// Right snap
		var _r_s = _r_b - cam_offset.x - target.width * 0.5;
		FlxSpriteUtil.drawLine(_overlay, _r_s, 48, _r_s, FlxG.height - 48);
		FlxSpriteUtil.drawPolygon(_overlay, [FlxPoint.get(_r_s + 1, 48 - 8), FlxPoint.get(_r_s + 1 - 8, 48 - 4), FlxPoint.get(_r_s + 1, 48)]);
		
		return _overlay;
	}
	
	override public function update(elapsed:Float):Void 
	{
		// Looking down or up...
		dolly_y_offset = 0;
		if (look_down) 
			dolly_y_offset += FlxG.width * 0.25;
		if (look_up) 
			dolly_y_offset -= FlxG.width * 0.25;
		
		// Moving up or down...
		if (target.wasTouching == FlxObject.FLOOR)
			y += ((target.y + dolly_y_offset - cam_offset.y - y) * 0.1).clamp(-max_dolly_velocity, max_dolly_velocity);
		if (!FlxG.overlap(this, target))
			y += target.velocity.y > 0 ? (target.velocity.y / FlxG.updateFramerate) : ((target.y + dolly_y_offset - cam_offset.y - y) * 0.1).clamp(-max_dolly_velocity, max_dolly_velocity);
		
		// Moving left or right...
		if (facing == FlxObject.RIGHT)
		{
			if (target.facing == FlxObject.RIGHT)
				x += ((target.x + target.width * 0.5 - cam_offset.x - x) * 0.1).clamp(-max_dolly_velocity, max_dolly_velocity);
			else if (!FlxG.overlap(this, target))
				facing = FlxObject.LEFT;
		}
		else
		{
			if (target.facing == FlxObject.LEFT)
				x += ((target.x + target.width * 0.5 - (width - cam_offset.x) - x) * 0.1).clamp(-max_dolly_velocity, max_dolly_velocity);
			else if (!FlxG.overlap(this, target))
				facing = FlxObject.RIGHT;
		}
		
		// Centering Target...
		if (should_center_target)
		{
			if ((getMidpoint().x - target.getMidpoint().x).abs() > 1)
				should_center_target = false;
			else
				x += ((target.getMidpoint().x - getMidpoint().x) * 0.1).clamp(-max_dolly_velocity, max_dolly_velocity);
		}
		
		super.update(elapsed);
	}
	
}