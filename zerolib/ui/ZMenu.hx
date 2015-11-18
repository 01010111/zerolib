package zerolib.ui;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import zerolib.ui.ZMenu.MenuItem;
import zerolib.util.ZMath;

/**
 * A Basic Framework for menus within HaxeFlixel. Each Menu Item is a FlxGroup that can hold several elements.
 * @author x01010111
 */
class ZMenu extends FlxTypedGroup<MenuItem>
{
	// Currently selected Menu Item
	var selected_item:MenuItem;
	
	// Cursor
	public var cursor:FlxSprite;
	
	// Modes
	public var interface_mode:Int = 0;
	public var mouse_mode:Int = 0;
	public var cursor_position_mode:Int = 0;
	
	// Callback Functions
	public var confirm_callback:Void->Void = function() { };
	public var select_callback:Void->Void = function() { };
	public var cancel_callback:Void->Void = function() { };
	
	// Bound Keys
	public var KEYS_UP:Array<FlxKey> = new Array();
	public var KEYS_DOWN:Array<FlxKey> = new Array();
	public var KEYS_LEFT:Array<FlxKey> = new Array();
	public var KEYS_RIGHT:Array<FlxKey> = new Array();
	public var KEYS_CONFIRM:Array<FlxKey> = new Array();
	public var KEYS_CANCEL:Array<FlxKey> = new Array();
	
	/**
	 * Menus!
	 */
	public function new() 
	{
		super();
	}
	
	/**
	 * Run this method AFTER adding all menu items
	 */
	public function init():Void
	{
		arrange_menu_item_sub_items();
		assign_relationships();
		selected_item = members[0];
		selected_item.on_hover();
	}
	
	/**
	 * A method to arrange menu items vertically.
	 * @param	_anchor			FlxPoint	Starting position for the first item.
	 * @param	_item_height	Float		The height of each menu item.
	 * @param	_padding		Float		The vertical space between each menu item.
	 */
	public function arrange_vertically(_anchor:FlxPoint, _item_height:Float, _padding:Float):Void 
	{ 
		for (i in 0...length) members[i].setPosition(_anchor.x, _anchor.y + (_item_height + _padding) * i); 
		assign_relationships();
	}
	
	/**
	 * A method to arrange menu items horizontally.
	 * @param	_anchor			FlxPoint	Starting position for the first item.
	 * @param	_item_width 	Float		The width of each menu item.
	 * @param	_padding    	Float		The horizontal space between each menu item.
	 */
	public function arrange_horizontally(_anchor:FlxPoint, _item_width:Float, _padding:Float):Void 
	{ 
		for (i in 0...length) members[i].setPosition(_anchor.x + (_item_width + _padding) * i, _anchor.y); 
		assign_relationships();
	}
	
	/**
	 * A method to arrange menu items in rows and columns.
	 * @param	_anchor			FlxPoint	Starting position for the first item.
	 * @param	_columns		Int			Amount of desired columns.
	 * @param	_item_size		FlxPoint	The width and height of each menu item.
	 * @param	_padding		FlxPoint	The horizontal and vertical space between each menu item.
	 */
	public function arrange_2D(_anchor:FlxPoint, _columns:Int, _item_size:FlxPoint, _padding:FlxPoint):Void 
	{
		for (i in 0...length) members[i].setPosition(_anchor.x + i % _columns * (_item_size.x + _padding.x), _anchor.y + Math.floor(i / _columns) * (_item_size.y + _padding.y)); 
		assign_relationships();
	}
	
	/**
	 * Manually Bind Menu Keys
	 * @param	_up			FlxKey	Up Key
	 * @param	_down		FlxKey	Down Key
	 * @param	_left		FlxKey	Left Key
	 * @param	_right		FlxKey	Right Key
	 * @param	_confirm	FlxKey	Confirm Key
	 * @param	_cancel		FlxKey	Cancel Key
	 */
	public function bind_keys(?_up:FlxKey, ?_down:FlxKey, ?_left:FlxKey, ?_right:FlxKey, ?_confirm:FlxKey, ?_cancel:FlxKey):Void
	{
		if (_up != null) KEYS_UP.push(_up);
		if (_down != null) KEYS_DOWN.push(_down);
		if (_left != null) KEYS_LEFT.push(_left);
		if (_right != null) KEYS_RIGHT.push(_right);
		if (_confirm != null) KEYS_RIGHT.push(_confirm);
		if (_cancel != null) KEYS_RIGHT.push(_cancel);
	}
	
	/**
	 * Quickly bind the UP / DOWN / LEFT / RIGHT Arrow keys to Menu directions
	 */
	public function bind_arrow_keys():Void
	{
		KEYS_UP.push(FlxKey.UP);
		KEYS_DOWN.push(FlxKey.DOWN);
		KEYS_LEFT.push(FlxKey.LEFT);
		KEYS_RIGHT.push(FlxKey.RIGHT);
	}
	
	/**
	 * Quickly bind the W / A / S / D keys to Menu directions
	 */
	public function bind_WASD():Void
	{
		KEYS_UP.push(FlxKey.W);
		KEYS_DOWN.push(FlxKey.S);
		KEYS_LEFT.push(FlxKey.A);
		KEYS_RIGHT.push(FlxKey.D);
	}
	/**
	 * Bind Menu Confirm Key
	 * @param	_confirm_key	FlxKey	Menu Confirm Key
	 */
	public function bind_confirm_key(_confirm_key:FlxKey):Void { KEYS_CONFIRM.push(_confirm_key); }
	
	/**
	 * Bind Menu Confirm Key
	 * @param	_confirm_key	FlxKey	Menu Confirm Key
	 */
	public function bind_cancel_key(_cancel_key:FlxKey):Void { KEYS_CONFIRM.push(_cancel_key); }
	
	override public function update(elapsed:Float):Void 
	{
		if (cursor != null)
		{
			if (interface_mode == ZMenuInterfaceMode.FOUR_WAY)
			{
				var cursor_position = FlxPoint.get();
				
				switch(cursor_position_mode)
				{
					case 0: cursor_position = FlxPoint.get(selected_item.p_x, selected_item.p_y);	// TOP_LEFT_CORNER
					case 1: cursor_position = selected_item.get_bottom_right_corner();				// BOTTOM_RIGHT_CORNER
					case 2: cursor_position = selected_item.get_center();							// CENTER
				}
				
				if (mouse_mode == ZMenuCursorMode.INSTANT)
				{
					cursor.setPosition(cursor_position.x, cursor_position.y);
				}
				
				else if (mouse_mode == ZMenuCursorMode.TWEEN)
				{
					cursor.x += (cursor_position.x - cursor.x) * 0.25; 
					cursor.y += (cursor_position.y - cursor.y) * 0.25; 
				}
				
				if (FlxG.keys.anyJustPressed(KEYS_UP)) select_item_up();
				if (FlxG.keys.anyJustPressed(KEYS_DOWN)) select_item_down();
				if (FlxG.keys.anyJustPressed(KEYS_LEFT)) select_item_left();
				if (FlxG.keys.anyJustPressed(KEYS_RIGHT)) select_item_right();
				if (FlxG.keys.anyJustPressed(KEYS_CONFIRM)) confirm_selection();
				if (FlxG.keys.anyJustPressed(KEYS_CANCEL)) cancel_callback();
			}
			else if (interface_mode == ZMenuInterfaceMode.MOUSE)
			{
				var m_pos = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
				cursor.setPosition(FlxG.mouse.x, FlxG.mouse.y);
				forEach( function(m:MenuItem):Void { if (m != selected_item && m_pos.inFlxRect(FlxRect.get(m.p_x, m.p_y, m.size.x, m.size.y))) select_new_item(selected_item, m); } );
				if (selected_item != null && !m_pos.inFlxRect(FlxRect.get(selected_item.p_x, selected_item.p_y, selected_item.size.x, selected_item.size.y))) 
				{
					selected_item.on_exit();
					selected_item = null;
				}
				else if (FlxG.mouse.justPressed) 
				{
					confirm_selection();
				}
				if (FlxG.keys.anyJustPressed(KEYS_CANCEL)) cancel_callback();
			}
		}
		
		// TODO: create some kind of mouse/key listener to be able to swap between FOUR-WAY and MOUSE modes.
		
		super.update(elapsed);
	}
	
	function select_item_up():Void { if (selected_item.item_up != null) select_new_item(selected_item, selected_item.item_up); }
	function select_item_down():Void { if (selected_item.item_down != null) select_new_item(selected_item, selected_item.item_down); }
	function select_item_left():Void { if (selected_item.item_left != null) select_new_item(selected_item, selected_item.item_left); }
	function select_item_right():Void { if (selected_item.item_right != null) select_new_item(selected_item, selected_item.item_right); }
	function confirm_selection():Void { if (selected_item != null) selected_item.callback(); }
	
	function arrange_menu_item_sub_items():Void
	{
		forEach( function(menu_item:MenuItem):Void { menu_item.forEach( function(sub:FlxObject):Void { sub.setPosition(sub.x + menu_item.p_x, sub.y + menu_item.p_y); } ); } );
	}
	
	function select_new_item(_old_item:MenuItem, _new_item:MenuItem):Void
	{
		if (_old_item != null && _old_item.on_exit != null) _old_item.on_exit();
		selected_item = _new_item;
		if (_new_item.on_hover != null) _new_item.on_hover();
	}
	
	function assign_relationships():Void
	{
		for (i in 0...length)
		{
			var up_array:Array<MenuItem> = new Array();
			var down_array:Array<MenuItem> = new Array();
			var left_array:Array<MenuItem> = new Array();
			var right_array:Array<MenuItem> = new Array();
			for (n in 0...length)
			{
				if (i != n)
				{
					var a = ZMath.toRelativeAngle(ZMath.angleBetween(members[i].p_x, members[i].p_y, members[n].p_x, members[n].p_y));
					if (a > 225 && a <= 315) 		up_array.push(members[n]);
					else if (a > 45 && a <= 135) 	down_array.push(members[n]);
					else if (a > 135 && a <= 225) 	left_array.push(members[n]);
					else							right_array.push(members[n]);
				}
			}
			
			members[i].item_up = find_closest_menu_item_in_array(FlxPoint.get(members[i].p_x, members[i].p_y), up_array);
			members[i].item_down = find_closest_menu_item_in_array(FlxPoint.get(members[i].p_x, members[i].p_y), down_array);
			members[i].item_left = find_closest_menu_item_in_array(FlxPoint.get(members[i].p_x, members[i].p_y), left_array);
			members[i].item_right = find_closest_menu_item_in_array(FlxPoint.get(members[i].p_x, members[i].p_y), right_array);
		}
	}
	
	function find_closest_menu_item_in_array(_parent:FlxPoint, _item_array:Array<MenuItem>):MenuItem
	{
		var _d1 = 9999.0;
		var closest_menu_item:MenuItem = null;
		for (i in 0..._item_array.length)
		{
			var _d2 = FlxMath.getDistance(_parent, FlxPoint.get(_item_array[i].p_x, _item_array[i].p_y));
			if (_d2 < _d1)
			{
				closest_menu_item = _item_array[i];
				_d1 = _d2;
			}
		}
		return closest_menu_item;
	}
	
}

class MenuItem extends FlxTypedGroup<FlxObject>
{
	
	public var callback:Void->Void = function() { };
	public var on_hover:Void->Void = function() { };
	public var on_exit:Void->Void = function() { };
	
	public var item_up:MenuItem;
	public var item_down:MenuItem;
	public var item_left:MenuItem;
	public var item_right:MenuItem;
	
	public var name:String;
	public var p_x:Float = 0;
	public var p_y:Float = 0;
	public var size:FlxPoint;
	
	public function new(_x:Float = 0, _y:Float = 0, _name:String, ?_size:FlxPoint)
	{
		name = _name;
		p_x = _x;
		p_y = _y;
		size = _size != null ? _size : FlxPoint.get(0, 0);
		super();
	}
	
	public function get_center():FlxPoint { return FlxPoint.get(p_x + size.x * 0.5, p_y + size.y * 0.5); }
	
	public function get_bottom_right_corner():FlxPoint { return FlxPoint.get(p_x + size.x - 2, p_y + size.y - 2); }
	
	public function setPosition(_x:Float, _y:Float):Void
	{
		forEach(function(sub:FlxObject):Void { 
			var offset = FlxPoint.get(sub.x - p_x, sub.y - p_y);
			sub.setPosition(_x + offset.x, _y + offset.y);
		} );
		p_x = _x;
		p_y = _y;
	}
	
}

class ZMenuCursorMode
{
	public static var INSTANT:Int = 0;
	public static var TWEEN:Int = 1;
}

class ZMenuInterfaceMode
{
	public static var MOUSE:Int = 0;
	public static var FOUR_WAY:Int = 1;
}

class ZMenuCursorPositionMode
{
	public static var TOP_LEFT:Int = 0;
	public static var BOTTOM_RIGHT:Int = 1;
	public static var CENTER:Int = 2;
}