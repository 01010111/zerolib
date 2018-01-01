package zero.flxutil.controllers;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

class ZPlayerController extends ZBaseController
{

    var bindings:KeyBindings;
    var p:Int;
    var joypad:ZJoypad;

    /**
     *  Creates a controller to interface with the user.
     *  TODO: create joypad support
     *  
     */
    public function new(player:Int = 0)
    {
        super();
        p = player;
        bindings = new KeyBindings();
        joypad = new ZJoypad(p);
    }

    override public function update(e)
    {
        super.update(e);

        // DPAD

        state.dpad.u = (p1 && FlxG.keys.anyPressed([bindings.DPAD_UP])) || joypad.state.dpad.u;
        state.dpad.d = (p1 && FlxG.keys.anyPressed([bindings.DPAD_DOWN])) || joypad.state.dpad.d;
        state.dpad.l = (p1 && FlxG.keys.anyPressed([bindings.DPAD_LEFT])) || joypad.state.dpad.l;
        state.dpad.r = (p1 && FlxG.keys.anyPressed([bindings.DPAD_RIGHT])) || joypad.state.dpad.r;

        state.dpad.u_p = (p1 && FlxG.keys.anyJustPressed([bindings.DPAD_UP])) || joypad.state.dpad.u_p;
        state.dpad.d_p = (p1 && FlxG.keys.anyJustPressed([bindings.DPAD_DOWN])) || joypad.state.dpad.d_p;
        state.dpad.l_p = (p1 && FlxG.keys.anyJustPressed([bindings.DPAD_LEFT])) || joypad.state.dpad.l_p;
        state.dpad.r_p = (p1 && FlxG.keys.anyJustPressed([bindings.DPAD_RIGHT])) || joypad.state.dpad.r_p;

        state.dpad.u_r = (p1 && FlxG.keys.anyJustReleased([bindings.DPAD_UP])) || joypad.state.dpad.u_r;
        state.dpad.d_r = (p1 && FlxG.keys.anyJustReleased([bindings.DPAD_DOWN])) || joypad.state.dpad.d_r;
        state.dpad.l_r = (p1 && FlxG.keys.anyJustReleased([bindings.DPAD_LEFT])) || joypad.state.dpad.l_r;
        state.dpad.r_r = (p1 && FlxG.keys.anyJustReleased([bindings.DPAD_RIGHT])) || joypad.state.dpad.r_r;

        // FACE BUTTONS

        state.face.a = (p1 && FlxG.keys.anyPressed([bindings.FACE_A])) || joypad.state.face.a;
        state.face.b = (p1 && FlxG.keys.anyPressed([bindings.FACE_B])) || joypad.state.face.b;
        state.face.x = (p1 && FlxG.keys.anyPressed([bindings.FACE_X])) || joypad.state.face.x;
        state.face.y = (p1 && FlxG.keys.anyPressed([bindings.FACE_Y])) || joypad.state.face.y;

        state.face.a_p = (p1 && FlxG.keys.anyJustPressed([bindings.FACE_A])) || joypad.state.face.a_p;
        state.face.b_p = (p1 && FlxG.keys.anyJustPressed([bindings.FACE_B])) || joypad.state.face.b_p;
        state.face.x_p = (p1 && FlxG.keys.anyJustPressed([bindings.FACE_X])) || joypad.state.face.x_p;
        state.face.y_p = (p1 && FlxG.keys.anyJustPressed([bindings.FACE_Y])) || joypad.state.face.y_p;

        state.face.a_r = (p1 && FlxG.keys.anyJustReleased([bindings.FACE_A])) || joypad.state.face.a_r;
        state.face.b_r = (p1 && FlxG.keys.anyJustReleased([bindings.FACE_B])) || joypad.state.face.b_r;
        state.face.x_r = (p1 && FlxG.keys.anyJustReleased([bindings.FACE_X])) || joypad.state.face.x_r;
        state.face.y_r = (p1 && FlxG.keys.anyJustReleased([bindings.FACE_Y])) || joypad.state.face.y_r;

        // SHOULDER BUMPERS

        state.bmpr.l = (p1 && FlxG.keys.anyPressed([bindings.BMPR_L])) || joypad.state.bmpr.l;
        state.bmpr.r = (p1 && FlxG.keys.anyPressed([bindings.BMPR_R])) || joypad.state.bmpr.r;

        state.bmpr.l_p = (p1 && FlxG.keys.anyJustPressed([bindings.BMPR_L])) || joypad.state.bmpr.l_p;
        state.bmpr.r_p = (p1 && FlxG.keys.anyJustPressed([bindings.BMPR_R])) || joypad.state.bmpr.r_p;

        state.bmpr.l_r = (p1 && FlxG.keys.anyJustReleased([bindings.BMPR_L])) || joypad.state.bmpr.l_r;
        state.bmpr.r_r = (p1 && FlxG.keys.anyJustReleased([bindings.BMPR_R])) || joypad.state.bmpr.r_r;

        // UTILITY BUTTONS

        state.util.p = (p1 && FlxG.keys.anyPressed([bindings.UTIL_P])) || joypad.state.util.p;
        state.util.m = (p1 && FlxG.keys.anyPressed([bindings.UTIL_M])) || joypad.state.util.m;

        state.util.p_p = (p1 && FlxG.keys.anyJustPressed([bindings.UTIL_P])) || joypad.state.util.p_p;
        state.util.m_p = (p1 && FlxG.keys.anyJustPressed([bindings.UTIL_M])) || joypad.state.util.m_p;

        state.util.p_r = (p1 && FlxG.keys.anyJustReleased([bindings.UTIL_P])) || joypad.state.util.p_r;
        state.util.m_r = (p1 && FlxG.keys.anyJustReleased([bindings.UTIL_M])) || joypad.state.util.m_r;
    }

    /**
     *  Returns this controller's joypad
     *  @return  Joypad
     */
    public function get_joypad():Joypad
    {
        return joypad;
    }

    /**
     *  Returns this controller's left analog stick state
     *  @return FlxPoint
     */
    public function left_analog():FlxPoint
    {
        if (joypad.get_pad() == null) return FlxPoint.get();
        return joypad.get_left_analog_state():
    }

    override public function add()
    {
        super.add();
        FlxG.state.add(joypad);
    }

}

class KeyBindings
{

    public var DPAD_UP:FlxKey;
    public var DPAD_DOWN:FlxKey;
    public var DPAD_LEFT:FlxKey;
    public var DPAD_RIGHT:FlxKey;

    public var FACE_A:FlxKey;
    public var FACE_B:FlxKey;
    public var FACE_X:FlxKey;
    public var FACE_Y:FlxKey;

    public var BMPR_L:FlxKey;
    public var BMPR_R:FlxKey;

    public var UTIL_P:FlxKey;
    public var UTIL_M:FlxKey;

    /**
     *  Creates the keybindings to be used by the player on keyboard
     *  
     */
    public function new()
    {
        set_default_bindings_qwerty();
    }

    /**
     *  Sets the default bindings for QWERTY keyboards
     *  TODO: add bindings for other keyboard types
     */
    public function set_default_bindings_qwerty()
    {
        set_dpad_arrowkeys();

        bind_key('FACE_A', FlxKey.Z);
        bind_key('FACE_B', FlxKey.A);
        bind_key('FACE_X', FlxKey.X);
        bind_key('FACE_Y', FlxKey.S);

        bind_key('BMPR_L', FlxKey.Q);
        bind_key('BMPR_R', FlxKey.W);

        bind_key('UTIL_P', FlxKey.E);
        bind_key('UTIL_M', FlxKey.TAB);
    }

    /**
     *  Binds the DPAD buttons to the keyboard's arrow keys
     *  
     */
    public function set_dpad_arrowkeys()
    {
        bind_key('DPAD_UP', FlxKey.UP);
        bind_key('DPAD_DOWN', FlxKey.DOWN);
        bind_key('DPAD_LEFT', FlxKey.LEFT);
        bind_key('DPAD_RIGHT', FlxKey.RIGHT);
    }

    /**
     *  Binds the DPAD buttons to the keyboard's WASD keys
     *  
     */
    public function set_dpad_wasd()
    {
        bind_key('DPAD_UP', FlxKey.W);
        bind_key('DPAD_DOWN', FlxKey.A);
        bind_key('DPAD_LEFT', FlxKey.S);
        bind_key('DPAD_RIGHT', FlxKey.D);
    }

    /**
     *  Binds a specific button (action) to a key
     * 
     *  @param   _button    The controller button to map
     *  @param   _key       The key to bind to the button
     */
    public function bind_key(_button:String, _key)
    {
        switch(_button)
        {
            case 'DPAD_UP':     DPAD_UP = _key;
            case 'DPAD_DOWN':   DPAD_DOWN = _key;
            case 'DPAD_LEFT':   DPAD_LEFT = _key;
            case 'DPAD_RIGHT':  DPAD_RIGHT = _key;
            case 'FACE_A':      FACE_A = _key;
            case 'FACE_B':      FACE_B = _key;
            case 'FACE_X':      FACE_X = _key;
            case 'FACE_Y':      FACE_Y = _key;
            case 'BMPR_L':      BMPR_L = _key;
            case 'BMPR_R':      BMPR_R = _key;
            case 'UTIL_P':      UTIL_P = _key;
            case 'UTIL_M':      UTIL_M = _key;
        }
    }

}