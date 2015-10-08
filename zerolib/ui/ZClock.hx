package zerolib.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import zerolib.util.ZBitmapText;

/**
 * ...
 * @author x01010111
 */
class ZClock extends FlxGroup
{
	
	var min:Int;
	var sec:Int = 0;
	var msc:Int = 0;
	var min_text:ZBitmapText;
	var sec_text:ZBitmapText;
	var msc_text:ZBitmapText;
	var colons:FlxSprite;
	var countdown:Bool;
	
	var bitmap_data_array_big:Array<Array<Int>> = [
		[1,1,1,1,1,0,1,1,1,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0],
		[1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0],
		[1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0],
		[1,0,0,0,1,0,0,0,1,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,1,0,1,1,1,1,1,0,1,1,1,1,1,0],
		[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0],
		[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0],
		[1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,1,0,1,1,1,1,1,0,0,0,0,0,1,0]
	];
	
	var bitmap_data_array_sm:Array<Array<Int>> = [
		[1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0],
		[1,0,1,0,0,1,0,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0],
		[1,0,1,0,0,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,0,0,1,0,1,1,1,0,1,1,1,0],
		[1,0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0],
		[1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,0,0,1,0,1,1,1,0,1,1,1,0,0,0,1,0,1,1,1,0,0,0,1,0]
	];
	
	public function new(_p:FlxPoint, _min:Int = 5, _countdown:Bool = true, _text_color:Int = 0xffd3ffff, _bg_color:Int = 0xff111111, _big:Bool = false) 
	{
		super();
		
		countdown = _countdown;
		countdown ? min = _min : min = 0;
		
		//BG
		var bg:FlxSprite = new FlxSprite(_p.x, _p.y);
		_big ? bg.makeGraphic(43, 11, _bg_color) : bg.makeGraphic(31, 9, _bg_color);
		bg.scrollFactor.set();
		add(bg);
		
		//COLONS
		colons = new FlxSprite(bg.x, bg.y);
		colons.makeGraphic(Math.round(bg.width), Math.round(bg.height), 0x00ffffff);
		if (_big)
		{
			FlxSpriteUtil.drawRect(colons, 14, 3, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 14, 6, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 28, 3, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 28, 6, 1, 1, _text_color);
		}
		else
		{
			FlxSpriteUtil.drawRect(colons, 10, 3, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 10, 6, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 20, 3, 1, 1, _text_color);
			FlxSpriteUtil.drawRect(colons, 20, 6, 1, 1, _text_color);
		}
		colons.scrollFactor.set();
		add(colons);
		
		//TEXT
		if (_big)
		{
			var bitmap_data:BitmapData = new BitmapData(60, 7, true, 0xffffffff);
			for (y in 0...bitmap_data_array_big.length)
			{
				for (x in 0...bitmap_data_array_big[y].length)
				{
					if (bitmap_data_array_big[y][x] == 1)
					{
						bitmap_data.setPixel(x, y, _text_color);
					}
					else bitmap_data.setPixel(x, y, 0x00000000);
				}
			}
			var _offset = 14;
			min_text = new ZBitmapText(bg.x + 2, bg.y + 2, "0123456789", FlxPoint.get(6, 7), bitmap_data);
			add(min_text);
			sec_text = new ZBitmapText(bg.x + 2 + _offset, bg.y + 2, "0123456789", FlxPoint.get(6, 7), bitmap_data);
			add(sec_text);
			msc_text = new ZBitmapText(bg.x + 2 + _offset * 2, bg.y + 2, "0123456789", FlxPoint.get(6, 7), bitmap_data);
			add(msc_text);
		}
		else 
		{
			var bitmap_data:BitmapData = new BitmapData(40, 5, true, 0xffffffff);
			for (y in 0...bitmap_data_array_sm.length)
			{
				for (x in 0...bitmap_data_array_sm[y].length)
				{
					if (bitmap_data_array_sm[y][x] == 1)
					{
						bitmap_data.setPixel(x, y, _text_color);
					}
					else bitmap_data.setPixel(x, y, 0x00000000);
				}
			}
			var _offset = 10;
			min_text = new ZBitmapText(bg.x + 2, bg.y + 2, "0123456789", FlxPoint.get(4, 5), bitmap_data);
			add(min_text);
			sec_text = new ZBitmapText(bg.x + 2 + _offset, bg.y + 2, "0123456789", FlxPoint.get(4, 5), bitmap_data);
			add(sec_text);
			msc_text = new ZBitmapText(bg.x + 2 + _offset * 2, bg.y + 2, "0123456789", FlxPoint.get(4, 5), bitmap_data);
			add(msc_text);
		}
		
		new FlxTimer().start(0.5, null, 0).onComplete = function(t:FlxTimer):Void
		{
			colons.visible = colons.visible ? false : true;
		}
	}
	
	var counting:Bool = true;
	
	override public function update(elapsed:Float):Void 
	{
		msc--;
		
		if (min >= 0 && counting)
		{
			if (countdown)
			{
				if (msc < 0)
				{
					msc = FlxG.drawFramerate - 1;
					sec--;
					
					if (sec < 0)
					{
						sec = 59;
						min--;
					}
				}
			}
			else
			{
				if (msc > FlxG.drawFramerate - 1)
				{
					msc = 0;
					sec++;
					
					if (sec > 59)
					{
						sec = 0;
						min++;
					}
				}
			}
		}
		else
		{
			min = sec = msc = 0;
			counting = false;
		}
		
		setText();
		
		super.update(elapsed);
	}
	
	function setText():Void
	{
		min_text.text = min < 10 ? "0" + min : "" + min;
		sec_text.text = sec < 10 ? "0" + sec : "" + sec;
		msc_text.text = msc < 10 ? "0" + msc : "" + msc;
	}
	
	public function get_minutes():Int { return min; }
	public function get_seconds():Int { return sec; }
	public function get_milisec():Int { return msc; }
	
	public function get_time_string():String { return "" + min + ":" + sec + ":" + msc; }
	
}