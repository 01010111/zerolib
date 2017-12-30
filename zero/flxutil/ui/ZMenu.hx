package zero.flxutil.ui;

import flixel.FlxBasic;
import flixel.text.FlxText;

class ZMenu extends FlxBasic
{

    public var active_item:MenuItem;
    public var select_plus: Void -> Bool = function(){ return false; };
    public var select_minus: Void -> Bool = function(){ return false; };
    public var choose: Void -> Bool = function(){ return false; };
    public var back: Void -> Bool = function(){ return false; };
    public var exit: Void -> Void = function(){ /* ᴗ */ };

    var root_menu_item:MenuItem;
    var debug_text:FlxText;

    public function new(root_menu_item:MenuItem)
    {
        super();
        this.root_menu_item = root_menu_item;
        this.root_menu_item.set_menu(this);
        active_item = this.root_menu_item;
    }

    public function get_debug_text(x:Float, y:Float):FlxText
    {
        debug_text = new FlxText(x, y);
        return debug_text;
    }

    override public function update(e:Float)
    {
        if (select_plus()) active_item.select_item(1);
        if (select_minus()) active_item.select_item(-1);
        if (choose()) active_item.choose_selected_item();
        if (back()) active_item.go_back();

        if (debug_text == null) return;

        var t = '${active_item.title}\n';
        for (i in 0...active_item.children.length) 
            i == active_item.selection_index ? 
                t += ' >${active_item.children[i].title}\n': 
                t += '  ${active_item.children[i].title}\n';
        debug_text.text = t;
    }

}

class MenuItem
{

    public var menu:ZMenu;
    public var parent:MenuItem;
    public var title:String;
    public var type:Int;
    public var selected_item:MenuItem;
    public var children:Array<MenuItem> = [];
    public var selection_index:Int = 0;
    public var selection_callback:Int -> Void = function (idx:Int) { /* ᴗ */ };
    public var on_choose_callback:Int -> Void = function (idx:Int) { /* ᴗ */ };

    public function new(title:String, type:Int = 0)
    {
        this.title = title;
        this.type = type;
    }

    public function add_child(child:MenuItem, select:Bool = false)
    {
        child.parent = this;
        if (menu != null) child.menu = menu;
        children.push(child);
        if (children.length == 1 || select) selected_item = child;
    }

    public function set_menu(menu:ZMenu)
    {
        this.menu = menu;
        for (child in children) child.set_menu(menu);
    }

    public function select_item(idx_delta:Int = 1)
    {
        selection_index = (((selection_index + idx_delta) - 0) % (children.length - 0) + (children.length - 0)) % (children.length - 0) + 0;
        selected_item = children[selection_index];
        selection_callback(selection_index);
    }

    public function choose_selected_item()
    {
        if (selected_item.children.length == 0) on_choose_callback();
        menu.active_item = selected_item;
    }

    public function go_back()
    {
        if (parent != null) menu.active_item = parent;
        else menu.exit();
    }

}