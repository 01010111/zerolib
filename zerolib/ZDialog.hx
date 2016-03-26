package zerolib;

//{ libraries

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;

//}

//{ ZDialog

/**
 * THIS IS NOT READY! :) I'm just pushing it so I can work on it on other computers!
 * @author 01010111
 */
class ZDialog extends FlxSubState
{

	var background_sprite:FlxSprite;
	
	var main_text:TextBox;
	
	var portrait_sprite:FlxSprite;
	
	var title_text:TextBox;
	var title_background:FlxSprite;
	
	var choice_text:TextBox;
	var choice_background:FlxSprite;
	var choice_cursor:FlxSprite;
	var has_choice:Bool = false;
	
	var continue_sprite:FlxSprite;
	var complete_sprite:FlxSprite;
	
	public static var TRANSITION_FROM_BOTTOM:Int = 1;
	public static var TRANSITION_FROM_TOP:Int = 2;
	public static var TRANSITION_FROM_LEFT:Int = 3;
	public static var TRANSITION_FROM_RIGHT:Int = 4;
	
	public function new(dialog_style:DialogStyle, text:String, transition:Int = 0) 
	{
		super();
		
		background_sprite = dialog_style.background.background_sprite;
		background_sprite.setPosition(dialog_style.background.background_offset.x, dialog_style.background.background_offset.y);
		background_sprite.scrollFactor.set();
		add(background_sprite);
		
		main_text = new TextBox(dialog_style.main_text, text, FlxPoint.get(background_sprite.x, background_sprite.y));
		add(main_text);
	}
	
}

//}

//{ TextBox

/**
 * ...
 * @author 01010111
 */
class TextBox extends FlxTypedGroup<Letter>
{
	
	var max_columns:Int;
	var max_rows:Int;
	
	var pages:Array<String>;
	
	public function new(_style:TextStyle, _text:String, _position:FlxPoint)
	{
		super();
		
		max_columns = _style.max_columns != null ? _style.max_columns : 64;
		max_rows = _style.max_rows != null ? _style.max_rows : 8;
		
		pages = parse_pages(split_pages(split_lines(split_words(_text))));
		//FlxG.log.warn(pages[1]);
		
		var _leading = _style.leading != null ? _style.leading : 0;
		var _kerning = _style.kerning != null ? _style.kerning : 0;
		
		var _origin = FlxPoint.get(_position.x + _style.offset.x, _position.y + _style.offset.y);
		var _off = FlxPoint.get(_style.frame_size.x + _leading, _style.frame_size.y + _kerning);
		var _x:Int = 0;
		var _y:Int = 0;
		
		for (i in 0...pages[0].length)
		{
			var _p = FlxPoint.get(_x * _off.x + _origin.x, _y * _off.y + _origin.y);
			add(new Letter(_style.graphic, _style.alphabet, _style.frame_size, pages[0].charAt(i), _p));
			//FlxG.log.add(pages[0].charAt(i) + " / " + _x + " / " + _y);
			_x++;
			if (pages[0].charAt(i) == "\n")
			{
				_x = 0;
				_y++;
			}
		}
	}
	
	function split_words(_text:String):Array<String>
	{
		return _text.split(" ");
	}
	
	function split_lines(_words:Array<String>):Array<Array<String>>
	{
		//FIGURE IT OUT
		var _lines:Array<Array<String>> = new Array();
		_lines[0] = new Array();
		var _char = 0;
		var _line = 0;
		for (i in 0..._words.length)
		{
			_char += _words[i].length + 1;
			if (_char >= max_columns)
			{
				_char = _words[i].length + 1;
				_line++;
				_lines[_line] = new Array();
			}
			_lines[_line].push(_words[i]);
		}
		//FlxG.log.add(_lines);
		return _lines;
	}
	
	function split_pages(_lines:Array<Array<String>>):Array<Array<Array<String>>>
	{
		var _pages:Array<Array<Array<String>>> = new Array();
		_pages[0] = new Array();
		var _row = 0;
		var _page = 0;
		for (i in 0..._lines.length)
		{
			if (_row < max_rows)
			{
				_row++;
			}
			else 
			{
				_row = 0;
				_page++;
				_pages[_page] = new Array();
			}
			_pages[_page].push(_lines[i]);
		}
		//FlxG.log.add(_pages);
		return _pages;
	}
	
	function parse_pages(_pages:Array<Array<Array<String>>>):Array<String>
	{
		var _new_pages:Array<String> = [""];
		
		for (page in 0..._pages.length)
		{
			for (line in 0..._pages[page].length)
			{
				for (word in 0..._pages[page][line].length)
				{
					_new_pages[page] += _pages[page][line][word] + " ";
				}
				
				_new_pages[page] += "\n";
			}
			_new_pages[page + 1] = "";
		}
		return _new_pages;
	}
	
}

//}

//{ Letter

/**
 * ...
 * @author 01010111
 */
class Letter extends FlxSprite
{
	
	public function new(_graphic:FlxGraphicAsset, _alphabet:String, _size:IntPoint, _letter:String, _pos:FlxPoint)
	{
		super(_pos.x, _pos.y);
		loadGraphic(_graphic, true, _size.x, _size.y);
		scrollFactor.set();
		var loaded:Bool = false;
		for (i in 0..._alphabet.length)
		{
			if (_letter == _alphabet.charAt(i))
			{
				animation.frameIndex = i;
				loaded = true;
			}
		}
		if (!loaded)
			FlxG.log.warn("Character " + "'" + _letter + "'" + " not in alphabet!");
	}
	
}

//}

//{ typedef Circus :P

typedef DialogStyle =
{
	main_text:TextStyle,
	background:BackgroundStyle,
	?portrait:PortraitStyle,
	?title:TitleStyle,
	?choice:ChoiceStyle,
	?continue_sprite:FlxSprite,
	?complete_sprite:FlxSprite
}

typedef BackgroundStyle =
{
	background_sprite:FlxSprite,
	background_offset:FlxPoint
}

typedef PortraitStyle =
{
	portrait_sprite:FlxSprite,
	portrait_offset:FlxSprite,
	?add_to_back:Bool
}

typedef TitleStyle =
{
	title_offset:FlxPoint,
	title_string:String,
	?title_text:TextStyle,
	?title_sprite:FlxSprite
}

typedef ChoiceStyle =
{
	choice_1:String,
	choice_2:String,
	cursor:FlxSprite,
	cursor_offset_from_text:FlxPoint,
	?choice_text:TextStyle,
	?choice_background:FlxSprite,
	?seperator:String
}

typedef TextStyle =
{
	graphic:FlxGraphicAsset,
	alphabet:String,
	frame_size:IntPoint,
	offset:FlxPoint,
	?leading:Float,
	?kerning:Float,
	?type_out:Bool,
	?max_columns:Int,
	?max_rows:Int,
	?color:Int,
	?rainbow:Bool,
	?wiggle:WiggleStyle,
	?shake:ShakeStyle
}

typedef WiggleStyle =
{
	speed:Float,
	amplitude:Float
}

typedef ShakeStyle =
{
	speed:Float,
	horizontal_amplitude:Float,
	vertical_amplitude:Float
}

typedef IntPoint = 
{
	x:Int,
	y:Int
}

//}