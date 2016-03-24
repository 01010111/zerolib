package zerolib;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.ui.FlxVirtualPad.FlxActionMode;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;

/**
 * ...
 * @author 01010111
 */
class ZSpotLight extends FlxSprite
{
	
	var lights:FlxTypedGroup<Light>;
	var darkness_color:Int;

	public function new(_darkness_color:Int = 0xd0000010) 
	{
		super();
		
		makeGraphic(FlxG.width, FlxG.height, _darkness_color);
		scrollFactor.set();
		blend = BlendMode.MULTIPLY;
		darkness_color = _darkness_color;
		
		lights = new FlxTypedGroup();
	}
	
	public function add_light_target(_target:FlxObject, _light_size:Int):Void
	{
		lights.add(new Light(_target, _light_size));
	}
	
	public function add_light_targets(_targets:FlxTypedGroup<Dynamic>, _light_size:Int):Void
	{
		for (target in _targets)
		{
			add_light_target(target, _light_size);
		}
	}
	
	public function add_to_state():Void
	{
		FlxG.state.add(this);
		FlxG.state.add(lights);
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxSpriteUtil.fill(this, darkness_color);
		
		for (light in lights)
		{
			light.alpha = 1;
			stamp(light, Std.int(light.x), Std.int(light.y));
			light.alpha = 0;
		}
		
		super.update(elapsed);
	}
	
}

class Light extends FlxSprite
{
	
	var target:FlxObject;
	
	public function new (_target:FlxObject, _light_size:Int):Void
	{
		target = _target;
		super();
		var _s = target.exists ? 1 : 0;
		scale.set(_s, _s);
		makeGraphic(_light_size, _light_size, 0x00ffffff);
		FlxSpriteUtil.drawCircle(this);
		blend = BlendMode.SCREEN;
	}
	
	override public function update(elapsed:Float):Void 
	{
		var _t = FlxPoint.get((target.getScreenPosition().x + target.width * 0.5) - width * 0.5, (target.getScreenPosition().y + target.height * 0.5) - height * 0.5);
		
		if (ZMath.distance(getMidpoint(), target.getMidpoint()) > 32)
			setPosition(_t.x, _t.y);
		else
		{
			x += (_t.x - x) * 0.5;
			y += (_t.y - y) * 0.5;
		}
		
		var _s = target.exists ? 1 : 0;
		scale.x += (_s - scale.x) * 0.05;
		scale.y += (_s - scale.y) * 0.05;
		
		super.update(elapsed);
	}
	
}