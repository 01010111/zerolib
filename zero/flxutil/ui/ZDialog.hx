package zerolib;

//{ libraries

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
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
	public static var instance:ZDialog;

	var background_sprite:FlxSprite;
	var main_text:TextBox;
	var portrait:FlxSprite;
	var title_bg:FlxSprite;
	var title_text:TextBox;

	public function new(dialog_style:DialogStyle, text:String) 
	{
		super();
		
		instance = this;

		var bg_group:FlxGroup = new FlxGroup();
		add(bg_group);

		var _p = FlxPoint.get(dialog_style.background.offset.x, dialog_style.background.offset.y);
		if (dialog_style.background.sprite != null) 
		{
			background_sprite = dialog_style.background.sprite;
			background_sprite.setPosition(_p.x, _p.y);
		}
		else
		{
			background_sprite = new FlxSprite(_p.x, _p.y);
			var _size_x = _p.x < FlxG.width * 0.5 ? _p.x * 2 : (_p.x - FlxG.width * 0.5) * 2;
			var _size_y = _p.y < FlxG.height * 0.5 ? _p.y * 2 : (_p.y - FlxG.height * 0.5) * 2;
			background_sprite.makeGraphic(Std.int(_size_x), Std.int(_size_y), 0x00ffffff);
		}
		background_sprite.scrollFactor.set();
		add(background_sprite);
		
		main_text = new TextBox(dialog_style.text, text, _p, dialog_style.controls);
		add(main_text);

		if (dialog_style.portrait != null)
		{
			portrait = dialog_style.portrait.sprite;
			portrait.setPosition
			(
				_p.x + dialog_style.portrait.offset.x, 
				_p.y + dialog_style.portrait.offset.y
			);
			portrait.scrollFactor.set();
			dialog_style.portrait.add_to_back ? bg_group.add(portrait) : add(portrait);
			add(portrait);
			if (dialog_style.portrait.on_appear != null)
				dialog_style.portrait.on_appear(portrait);
		}

		if (dialog_style.title != null)
		{
			var title = dialog_style.title;

			if (title.bg != null)
			{
				title_bg = title.bg.sprite;
				title_bg.setPosition
				(
					_p.x + title.bg.offset.x, 
					_p.y + title.bg.offset.y
				);
				title_bg.scrollFactor.set();
				add(title_bg);
			}

			var _title_text = title.text != null ? title.text : dialog_style.text;
			_title_text.offset = title.offset;
			title_text = new TextBox(_title_text, title.string, _p);
			add(title_text);
		}
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
	var style:TextStyle;

	var max_columns:Int;
	var max_rows:Int;
	var controls:MenuControls;
	var pages:Array<String>;

	var leading:Float;
	var kerning:Float;
	var origin:FlxPoint;
	var offset:FlxPoint;

	var current_page_text:String;
	var current_page:Int = 0;
	var current_letter:Int = 0;
	var column:Int = 0;
	var row:Int = 0;
	var frames_per_tick:Int;
	var tick:Int;
	var page_completed:Bool = false;

	var continue_sprite:FlxSprite;
	var complete_sprite:FlxSprite;
	var indicator_transition:Int;

	var tick_callback:Void -> Void = function() { };
	var page_callback:Void -> Void = function() { };
	
	public function new(_style:TextStyle, _text:String, _position:FlxPoint, ?_controls:MenuControls)
	{
		super();

		style = _style;
		if (_controls != null)
			controls = _controls;
				
		max_columns = style.max_columns != null ? style.max_columns : Std.int(Math.POSITIVE_INFINITY);
		max_rows = style.max_rows != null ? style.max_rows : Std.int(Math.POSITIVE_INFINITY);

		pages = parse_pages(split_pages(split_lines(split_words(_text))));

		leading = style.leading != null ? style.leading : 0;
		kerning = style.kerning != null ? style.kerning : 0;
		frames_per_tick = style.frames_per_tick != null ? style.frames_per_tick : 0;
		origin = FlxPoint.get(_position.x + style.offset.x, _position.y + style.offset.y);
		offset = FlxPoint.get(style.frame_size.x + leading, style.frame_size.y + kerning);

		if (style.tick_callback != null) 
			tick_callback = style.tick_callback;
		if (style.page_callback != null)
			page_callback = style.page_callback;

		current_page_text = pages[current_page];

		if (controls != null && style.indicators != null)
		{
			continue_sprite = style.indicators.continue_sprite;
			complete_sprite = style.indicators.complete_sprite != null ?
				style.indicators.complete_sprite :
				style.indicators.continue_sprite;

			var _p = FlxPoint.get
			(
				_position.x + style.indicators.offset.x, 
				_position.y + style.indicators.offset.y
			);
			continue_sprite.setPosition(_p.x, _p.y);
			complete_sprite.setPosition(_p.x, _p.y);

			continue_sprite.scrollFactor.set();
			complete_sprite.scrollFactor.set();

			continue_sprite.exists = complete_sprite.exists = false;

			ZDialog.instance.add(continue_sprite);
			ZDialog.instance.add(complete_sprite);
		}
	}

	function split_words(_text:String):Array<String>
	{
		return _text.split(" ");
	}
	
	function split_lines(_words:Array<String>):Array<Array<String>>
	{
		FlxG.log.add(_words);
		var _lines:Array<Array<String>> = new Array();
		_lines[0] = new Array();
		var _char = 0;
		var _line = 0;
		for (i in 0..._words.length)
		{
			var _new_page = _words[i] == "[p]";
			var _new_line = _words[i] == "[n]";

			if (!_new_page && !_new_line)
			{
				_char += _words[i].length + 1;
				if (_char >= max_columns)
				{
					_char = _words[i].length + 1;
					_line++;
					_lines[_line] = new Array();
				}
			}
			else
			{
				_char = 0;
				_line++;
				_lines[_line] = new Array();
			}

			if (!_new_line) 
				_lines[_line].push(_words[i]);
		}
		
		return _lines;
	}
	
	function split_pages(_lines:Array<Array<String>>):Array<Array<Array<String>>>
	{
		FlxG.log.add(_lines);
		var _pages:Array<Array<Array<String>>> = new Array();
		_pages[0] = new Array();
		var _row = 0;
		var _page = 0;
		for (i in 0..._lines.length)
		{
			var _new_page = _lines[i][0] == "[p]";

			if (!_new_page && _row < max_rows - 1)
				_row++;
			else 
			{
				_row = 0;
				_page++;
				_pages[_page] = new Array();
			}

			_pages[_page].push(_lines[i]);
		}
		return _pages;
	}
	
	function parse_pages(_pages:Array<Array<Array<String>>>):Array<String>
	{
		FlxG.log.add(_pages);
		var _new_pages:Array<String> = new Array();
		
		for (page in 0..._pages.length)
		{
			for (line in 0..._pages[page].length)
			{
				for (word in 0..._pages[page][line].length)
				{
					if (_new_pages[page] == null)
						_new_pages[page] = "";
					_new_pages[page] += _pages[page][line][word].charAt(0) == "[" ?
						_pages[page][line][word] : _pages[page][line][word] + " ";
				}
				
				_new_pages[page] += "\n";
			}
		}
		return _new_pages;
	}

	function clear_text():Void
	{
		for (letter in members)
			letter.kill();
	}

	override public function update(e:Float):Void
	{
		if (controls != null)
		{
			if (controls.confirm())
			{
				if (current_letter < current_page_text.length)
					print_page();
				else
				{
					clear_text();
					current_page++;
					if (pages[current_page] != null && pages[current_page].length > 0)
					{
						row = 0;
						column = 0;
						current_letter = 0;
						current_page_text = pages[current_page];
						page_completed = false;

						show_hide_indicators(continue_sprite, false);
					}
					else
						ZDialog.instance.close();
				}
			}
		}
	
		if (current_letter < current_page_text.length)
		{
			if (frames_per_tick == 0)
			{
				print_page();
			}
			else
			{
				if (tick == 0)
				{
					tick = frames_per_tick;
					add_letter();
					tick_callback();
				}
				else tick--;
			}
		}
		else if (!page_completed)
		{
			page_completed = true;

			page_callback();

			if (pages[current_page + 1] != null && pages[current_page + 1].length > 0)
				show_hide_indicators(continue_sprite, true);
			else
				show_hide_indicators(complete_sprite, true);
		}

		super.update(e);
	}

	function show_hide_indicators(_sprite:FlxSprite, _exists:Bool):Void
	{
		if (_sprite != null)
		{
			if (_exists)
			{
				//TODO: Add transitions
				_sprite.exists = _exists;
			}
			else
			{
				//TODO: Add transitions
				_sprite.exists = _exists;
			}
		}
	}

	var _listen:Bool = false;
	var _ignore_next:Bool = true;

	function add_letter():Void
	{

		if (current_page_text.charAt(current_letter) == "[")
			_listen = true;

		if (!_listen)
		{
			var _p = FlxPoint.get(column * offset.x + origin.x, row * offset.y + origin.y);
			if (current_page_text.charAt(current_letter) == "\n")
			{
				column = 0;
				row++;
			}
			else
			{
				var _l = new Letter(style.graphic, style.alphabet, style.frame_size, current_page_text.charAt(current_letter), _p);
				add(_l);
				if (style.on_appear != null)
					style.on_appear(_l);
				column++;
			}
		}
		else if (current_page_text.charAt(current_letter) == "]")
			_listen = false;
		current_letter++;
	}

	function print_page():Void
	{
		for (i in current_letter...current_page_text.length)
			add_letter();
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
				break;
			}
		}
		if (!loaded)
			FlxG.log.warn("Character " + "'" + _letter + "'" + " not in alphabet!");
	}
	
}

//}

class TRANSITIONS
{
	public static var SCALE_TWEEN:Int = 1;
	public static var SCALE_ALPHA:Int = 2;
}

//{ typedef Circus :P

typedef DialogStyle =
{
	text:TextStyle,
	background:BackgroundStyle,
	controls:MenuControls,
	?portrait:PortraitStyle,
	?title:TitleStyle,
	?choice:ChoiceStyle,
	?timers:Timers
}

typedef Timers =
{
	before_text:Float,
	between_pages:Float,
	before_exit:Float
}

typedef IndicatorSprites =
{
	offset:FlxPoint,
	continue_sprite:FlxSprite,
	?complete_sprite:FlxSprite,
	?transition:Int,
	?on_appear:FlxSprite -> Void,	// Callback function for each letter on appear
	?on_remove:FlxSprite -> Void 	// Callback function for each letter on remove
}

typedef BackgroundStyle =
{
	offset:FlxPoint, 				// Position of background_sprite on the screen
	?sprite:FlxSprite,				// FlxSprite for background image (used for placement, can be transparent!)
	?on_appear:FlxSprite -> Void,	// Callback function for each letter on appear
	?on_remove:FlxSprite -> Void 	// Callback function for each letter on remove
}

typedef PortraitStyle =
{
	sprite:FlxSprite,				// FlxSprite to use for a character portrait
	offset:FlxPoint,		
	?add_to_back:Bool,
	?on_appear:FlxSprite -> Void,	// Callback function for each letter on appear
	?on_remove:FlxSprite -> Void 	// Callback function for each letter on remove
}

typedef TitleStyle =
{
	offset:FlxPoint,
	string:String,
	?text:TextStyle,
	?bg:BackgroundStyle
}

typedef ChoiceStyle =
{
	choice_1:String,
	choice_2:String,
	cursor:FlxSprite,
	cursor_offset:FlxPoint,
	?text:TextStyle,
	?background:BackgroundStyle,
	?seperator:String
}

typedef TextStyle =
{
	graphic:FlxGraphicAsset,		// Path to font graphic
	alphabet:String,				// String of glyphs in font graphic
	frame_size:IntPoint,			// IntPoint of font frame size (font must be monospaced!)
	offset:FlxPoint,				// Text box offset relative to background
	?indicators:IndicatorSprites,	// Sprites that indicate when text can be advanced
	?max_columns:Int,				// Max letters per line
	?max_rows:Int,					// Max lines of text per page
	?frames_per_tick:Int,			// To type out text, set this higher than zero
	?tick_callback:Void -> Void,	// Callback function for each tick (use for beeps or whatever)
	?page_callback:Void -> Void,	// Callback function for the completion of a page
	?leading:Float,					// Font leading (space between lines)
	?kerning:Float,					// Font kerning (space between letters)
	?color:Int,						// Color of text
	?rainbow:Bool,					// Rainbow effect
	?wave:WaveStyle,				// Wave effect - see WaveStyle
	?shake:ShakeStyle, 				// Shake effect - see ShakeStyle
	?on_appear:FlxSprite -> Void,	// Callback function for each letter on appear
	?on_remove:FlxSprite -> Void 	// Callback function for each letter on remove
}

typedef WaveStyle =
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

typedef MenuControls =
{
	confirm:Void -> Bool,
	?left:Void -> Bool,
	?right:Void -> Bool
}

//}

/* MARKUP CHEATSHEET!
	
	[p] - New Page
	[n] - New Line

*/

class Example extends FlxState
{

	override public function create():Void
	{

		var example_dialog = new ZDialog 			// Create a dialog box (I reccomend you make a class to help with this!)
		(
			{											// Set the dialog style 
				background:									// Set up the background
				{													
					offset:FlxPoint.get(16, 16)					// Set the position of the dialog box
				},
				text:										// Set up the main text box 
				{
					graphic:"path/to/font_image.png", 			// Pass the path to your font graphic
					alphabet:" ABCDEFG...", 					// Pass all of the glyphs in your font graphic
					frame_size:									// Pass the graphic's glyph frame size
					{
						x:7, 										// Glyph frame size width
						y:9											// Glyph frame size height
					},
					offset:FlxPoint.get(16, 16),				// Set position of the text box within the dialog box
				}, 
				controls:									// Set up the controls for the dialog box
				{
					confirm:function():Bool 					// Confirm advances text, advances pages, and exits the dialog box
					{
						return FlxG.keys.justPressed.X;				// You can pass any check that returns a bool.
					}
				}
			},
			"Enter your text here!"						// The text you want to display, must be all on one line!
		);	
	}

}