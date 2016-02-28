package zerolib.junk;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 01010111
 */
class ZDolly extends FlxObject
{
	
	var target:FlxSprite;
	var cam_offset:FlxPoint;
	var facing:Int;
	var should_move_y:Bool = false;
	
	public function new(_target:FlxSprite, _width_percent:Float = 50) 
	{
		super(64, 400, FlxG.width * (_width_percent / 100) - _target.width * 2, FlxG.height * 0.75 - _target.height * 2);
		
		target = _target;
		facing = _target.facing;
		cam_offset = FlxPoint.get(target.width, FlxG.height * 0.3 + target.height);
		
		FlxG.camera.targetOffset.y = -FlxG.height * 0.15;
		FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (target.wasTouching == FlxObject.FLOOR || !FlxG.overlap(this, target))
		{
			y += (target.y - cam_offset.y - y) * 0.05;
		}
		
		
		if (facing == FlxObject.RIGHT)
		{
			if (target.facing == FlxObject.RIGHT)
			{
				x += (target.x - cam_offset.x - x) * 0.05;
			}
			else if (!FlxG.overlap(this, target))
			{
				facing = FlxObject.LEFT;
			}
		}
		else
		{
			if (target.facing == FlxObject.LEFT)
			{
				x += (target.x - (width - cam_offset.x) - x) * 0.05;
			}
			else if (!FlxG.overlap(this, target))
			{
				facing = FlxObject.RIGHT;
			}
		}
		
		super.update(elapsed);
	}
	
}