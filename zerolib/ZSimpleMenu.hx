package zerolib;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.system.System;

/**
 * ...
 * @author 01010111
 */
class ZSimpleMenu extends FlxSubState
{
	public static var i:ZSimpleMenu;
	
	var items:FlxTypedGroup<MenuItem>;
	var cur_item:Int = 0;
	var return_text:ZBitmapText;
	
	public var alphabet_string:String;
	public var font_size:FlxPoint;
	public var font_graphic:String;
	
	public var choice_up:Bool;
	public var choice_down:Bool;
	public var choice_enter:Bool;
	public var choice_back:Bool;
	public var choice_back_released:Bool;
	
	public var close_callback:Void -> Void = function() { };
	
	public function new(_bg_color:Int, _highlight_color:Int, _alphabet_string:String, _font_size:FlxPoint, _font_graphic:String) 
	{
		i = this;
		
		super(_bg_color);
		
		alphabet_string = _alphabet_string;
		font_size = _font_size;
		font_graphic = _font_graphic;
		
		var bg = new FlxSprite(FlxG.width);
		bg.makeGraphic(FlxG.width, FlxG.height, 0xffff0000);
		bg.scrollFactor.set();
		FlxTween.tween(bg, { x:FlxG.width * 0.45}, 0.2);
		
		return_text = new ZBitmapText(0, FlxG.height * 0.5, alphabet_string, font_size, font_graphic, FlxTextAlign.RIGHT, Std.int(FlxG.width * 0.4));
		return_text.text = "RETURN";
		
		var _selection_highlight = new FlxSprite(0, return_text.y - 1);
		_selection_highlight.makeGraphic(FlxG.width, Std.int(font_size.y + 2), _highlight_color);
		_selection_highlight.scrollFactor.set();
		
		items = new FlxTypedGroup();
		
		add(bg);
		add(_selection_highlight);
		add(return_text);
		add(items);
	}

	public function add_menu_item(_menu_item_name:String, _menu_item_choices:Array<String>, _menu_item_choice_callback:Void -> Void, _menu_item_current_choice:Int = 0):Void
	{
		var menu_item = new MenuItem(_menu_item_name);
		for (i in 0..._menu_item_choices.length) menu_item.add_choice(_menu_item_choices[i]);
		menu_item.cur_choice = _menu_item_current_choice;
		menu_item.choice_callback = _menu_item_choice_callback;
		items.add(menu_item);
	}
	
	public function add_exit_item():Void
	{
		#if !flash
		add_menu_item("EXIT", ["ARE YOU SURE?", "YES"], function():Void { new FlxTimer().start(0.25).onComplete = function(t:FlxTimer):Void { System.exit(0); } } );
		#end
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		for (i in 0...items.members.length)
		{
			items.members[i].alpha = items.members[cur_item].selected ? 0 : 1;
			//if (i == cur_item) items.members[i].alpha = items.members[i].selected ? 0.5 : 1;
			items.members[i].x += items.members[cur_item].selected ? (FlxG.width * 0.25 - items.members[i].x) * 0.26 : (FlxG.width * 0.5 - items.members[i].x) * 0.26;
			items.members[i].y += ((FlxG.height * 0.5 + i * 10 - cur_item * 10 + 1) - items.members[i].y) * 0.26;
		}
		
		var was_selected = items.members[cur_item].selected;
		
		if (choice_back_released) items.members[cur_item].selected  = false;
		if (choice_enter) items.members[cur_item].selected  = true;
		
		if (items.members[cur_item].selected != was_selected)
		{
			//TODO: Callback?
		}
		
		if (!items.members[cur_item].selected)
		{
			//return_text.alpha = 0.5;
			return_text.x += (0 - return_text.x) * 0.26;
			if (choice_down) choice_select(1);
			if (choice_up) choice_select( -1);
			if (choice_back) exit_menu();
		}
		else 
		{
			return_text.alpha = 0;
			return_text.x += (FlxG.width * -0.25 - return_text.x) * 0.26;
		}
	}
	
	public function set_controls(_up:Bool, _down:Bool, _left:Bool, _left_released:Bool, _right:Bool):Void
	{
		choice_up = _up;
		choice_down = _down;
		choice_back = _left;
		choice_back_released = _left_released;
		choice_enter = _right;
	}
	
	function exit_menu():Void
	{
		close_callback();
		close();
	}
	
	function choice_select(_dir:Int):Void
	{
		var new_choice = false;
		if (_dir > 0)
		{
			if (cur_item < items.members.length - 1) 
			{
				new_choice = true;
				cur_item++;
			}
		}
		else
		{
			if (cur_item > 0) 
			{
				new_choice = true;
				cur_item--;
			}
		}
		if (new_choice) 
		{
			//TODO: Callbacks?
		}
	}
	
}

class MenuItem extends ZBitmapText
{
	public var choices_text:Array<String>;
	public var cur_choice:Int;
	public var choice_callback:Void -> Void = function() { };
	public var selected:Bool = false;
	
	public var choices:FlxTypedGroup<ZBitmapText>;
	
	public function new(_item_name:String):Void
	{
		super(FlxG.width * 0.5, FlxG.height * 0.5, ZSimpleMenu.i.alphabet_string, ZSimpleMenu.i.font_size, ZSimpleMenu.i.font_graphic, FlxTextAlign.LEFT);
		text = _item_name;
		choices = new FlxTypedGroup();
		choices_text = new Array();
	}
	
	public function add_choice(_choice:String):Void
	{
		var _c = new ZBitmapText(0, 0, ZSimpleMenu.i.alphabet_string, ZSimpleMenu.i.font_size, ZSimpleMenu.i.font_graphic, FlxTextAlign.LEFT);
		_c.text = _choice;
		choices.add(_c);
		choices_text.push(_choice);
		ZSimpleMenu.i.add(_c);
	}
	
	public function choice_select(_dir:Int):Void
	{
		var new_choice = false;
		if (_dir > 0)
		{
			if (cur_choice < choices.members.length - 1) 
			{
				new_choice = true;
				cur_choice++;
			}
		}
		else
		{
			if (cur_choice > 0) 
			{
				new_choice = true;
				cur_choice--;
			}
		}
		if (new_choice) 
		{
			choice_callback();
			//TODO: Callbacks?
		}
	}
	
	override public function update(e:Float):Void 
	{
		for (i in 0...choices.members.length)
		{
			choices.members[i].alpha = selected ? 1 : 0;
			if (selected && i == cur_choice) choices.members[i].alpha = 1;
			
			choices.members[i].x += selected ? (FlxG.width * 0.5 - choices.members[i].x) * 0.26 : (FlxG.width * 0.75 - choices.members[i].x) * 0.26;
			choices.members[i].y += ((FlxG.height * 0.5 + i * 10 - cur_choice * 10 + 1) - choices.members[i].y) * 0.26;
		}
		super.update(e);
		
		if (selected)
		{
			if (ZSimpleMenu.i.choice_down) choice_select(1);
			if (ZSimpleMenu.i.choice_up) choice_select(-1);
		}
	}
	
}