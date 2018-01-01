package zero.flxutil.controllers;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

/**
 *  @author 01010111 
 */
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

        state.dpad.u = FlxG.keys.anyPressed(bindings.DPAD_U)        || joypad.state.dpad.u;
        state.dpad.d = FlxG.keys.anyPressed(bindings.DPAD_D)        || joypad.state.dpad.d;
        state.dpad.l = FlxG.keys.anyPressed(bindings.DPAD_L)        || joypad.state.dpad.l;
        state.dpad.r = FlxG.keys.anyPressed(bindings.DPAD_R)        || joypad.state.dpad.r;

        state.dpad.u_p = FlxG.keys.anyJustPressed(bindings.DPAD_U)  || joypad.state.dpad.u_p;
        state.dpad.d_p = FlxG.keys.anyJustPressed(bindings.DPAD_D)  || joypad.state.dpad.d_p;
        state.dpad.l_p = FlxG.keys.anyJustPressed(bindings.DPAD_L)  || joypad.state.dpad.l_p;
        state.dpad.r_p = FlxG.keys.anyJustPressed(bindings.DPAD_R)  || joypad.state.dpad.r_p;

        state.dpad.u_r = FlxG.keys.anyJustReleased(bindings.DPAD_U) || joypad.state.dpad.u_r;
        state.dpad.d_r = FlxG.keys.anyJustReleased(bindings.DPAD_D) || joypad.state.dpad.d_r;
        state.dpad.l_r = FlxG.keys.anyJustReleased(bindings.DPAD_L) || joypad.state.dpad.l_r;
        state.dpad.r_r = FlxG.keys.anyJustReleased(bindings.DPAD_R) || joypad.state.dpad.r_r;

        // FACE BUTTONS

        state.face.a = FlxG.keys.anyPressed(bindings.FACE_A)        || joypad.state.face.a;
        state.face.b = FlxG.keys.anyPressed(bindings.FACE_B)        || joypad.state.face.b;
        state.face.x = FlxG.keys.anyPressed(bindings.FACE_X)        || joypad.state.face.x;
        state.face.y = FlxG.keys.anyPressed(bindings.FACE_Y)        || joypad.state.face.y;

        state.face.a_p = FlxG.keys.anyJustPressed(bindings.FACE_A)  || joypad.state.face.a_p;
        state.face.b_p = FlxG.keys.anyJustPressed(bindings.FACE_B)  || joypad.state.face.b_p;
        state.face.x_p = FlxG.keys.anyJustPressed(bindings.FACE_X)  || joypad.state.face.x_p;
        state.face.y_p = FlxG.keys.anyJustPressed(bindings.FACE_Y)  || joypad.state.face.y_p;

        state.face.a_r = FlxG.keys.anyJustReleased(bindings.FACE_A) || joypad.state.face.a_r;
        state.face.b_r = FlxG.keys.anyJustReleased(bindings.FACE_B) || joypad.state.face.b_r;
        state.face.x_r = FlxG.keys.anyJustReleased(bindings.FACE_X) || joypad.state.face.x_r;
        state.face.y_r = FlxG.keys.anyJustReleased(bindings.FACE_Y) || joypad.state.face.y_r;

        // SHOULDER BUMPERS

        state.bmpr.l = FlxG.keys.anyPressed(bindings.BMPR_L)        || joypad.state.bmpr.l;
        state.bmpr.r = FlxG.keys.anyPressed(bindings.BMPR_R)        || joypad.state.bmpr.r;

        state.bmpr.l_p = FlxG.keys.anyJustPressed(bindings.BMPR_L)  || joypad.state.bmpr.l_p;
        state.bmpr.r_p = FlxG.keys.anyJustPressed(bindings.BMPR_R)  || joypad.state.bmpr.r_p;

        state.bmpr.l_r = FlxG.keys.anyJustReleased(bindings.BMPR_L) || joypad.state.bmpr.l_r;
        state.bmpr.r_r = FlxG.keys.anyJustReleased(bindings.BMPR_R) || joypad.state.bmpr.r_r;

        // UTILITY BUTTONS

        state.util.p = FlxG.keys.anyPressed(bindings.UTIL_P)        || joypad.state.util.p;
        state.util.m = FlxG.keys.anyPressed(bindings.UTIL_M)        || joypad.state.util.m;

        state.util.p_p = FlxG.keys.anyJustPressed(bindings.UTIL_P)  || joypad.state.util.p_p;
        state.util.m_p = FlxG.keys.anyJustPressed(bindings.UTIL_M)  || joypad.state.util.m_p;

        state.util.p_r = FlxG.keys.anyJustReleased(bindings.UTIL_P) || joypad.state.util.p_r;
        state.util.m_r = FlxG.keys.anyJustReleased(bindings.UTIL_M) || joypad.state.util.m_r;
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
        return joypad.get_left_analog_state();
    }

    override public function add()
    {
        super.add();
        FlxG.state.add(joypad);
    }

}

class KeyBindings
{

    public static var BINDING_DPAD_U:String = 'DPAD_U';
    public static var BINDING_DPAD_D:String = 'DPAD_D';
    public static var BINDING_DPAD_L:String = 'DPAD_L';
    public static var BINDING_DPAD_R:String = 'DPAD_R';
    public static var BINDING_FACE_A:String = 'FACE_A';
    public static var BINDING_FACE_B:String = 'FACE_B';
    public static var BINDING_FACE_X:String = 'FACE_X';
    public static var BINDING_FACE_Y:String = 'FACE_Y';
    public static var BINDING_BMPR_L:String = 'BMPR_L';
    public static var BINDING_BMPR_R:String = 'BMPR_R';
    public static var BINDING_UTIL_P:String = 'UTIL_P';
    public static var BINDING_UTIL_M:String = 'UTIL_M';

    public var DPAD_U:Array<FlxKey>;
    public var DPAD_D:Array<FlxKey>;
    public var DPAD_L:Array<FlxKey>;
    public var DPAD_R:Array<FlxKey>;

    public var FACE_A:Array<FlxKey>;
    public var FACE_B:Array<FlxKey>;
    public var FACE_X:Array<FlxKey>;
    public var FACE_Y:Array<FlxKey>;

    public var BMPR_L:Array<FlxKey>;
    public var BMPR_R:Array<FlxKey>;

    public var UTIL_P:Array<FlxKey>;
    public var UTIL_M:Array<FlxKey>;

    /**
     *  Creates the keybindings to be used by the player on keyboard
     *  
     */
    public function new()
    {
        reset_bindings();
        set_default_bindings_qwerty();
    }

    public function reset_bindings()
    {
        DPAD_U = [];
        DPAD_D = [];
        DPAD_L = [];
        DPAD_R = [];
        FACE_A = [];
        FACE_B = [];
        FACE_X = [];
        FACE_Y = [];
        BMPR_L = [];
        BMPR_R = [];
        UTIL_P = [];
        UTIL_M = [];
    }

    /**
     *  Sets the default bindings for QWERTY keyboards
     *  TODO: add bindings for other keyboard types
     */
    public function set_default_bindings_qwerty()
    {
        set_dpad_arrowkeys();

        bind_key(BINDING_FACE_A, FlxKey.Z);
        bind_key(BINDING_FACE_B, FlxKey.A);
        bind_key(BINDING_FACE_X, FlxKey.X);
        bind_key(BINDING_FACE_Y, FlxKey.S);

        bind_key(BINDING_BMPR_L, FlxKey.Q);
        bind_key(BINDING_BMPR_R, FlxKey.W);

        bind_key(BINDING_UTIL_P, FlxKey.E);
        bind_key(BINDING_UTIL_M, FlxKey.TAB);
    }

    /**
     *  Binds the DPAD buttons to the keyboard's arrow keys
     *  
     */
    public function set_dpad_arrowkeys()
    {
        bind_key(BINDING_DPAD_U, FlxKey.UP);
        bind_key(BINDING_DPAD_D, FlxKey.DOWN);
        bind_key(BINDING_DPAD_L, FlxKey.LEFT);
        bind_key(BINDING_DPAD_R, FlxKey.RIGHT);
    }

    /**
     *  Binds the DPAD buttons to the keyboard's WASD keys
     *  
     */
    public function set_dpad_wasd()
    {
        bind_key(BINDING_DPAD_U, FlxKey.W);
        bind_key(BINDING_DPAD_D, FlxKey.A);
        bind_key(BINDING_DPAD_L, FlxKey.S);
        bind_key(BINDING_DPAD_R, FlxKey.D);
    }

    /**
     *  Binds a specific button (action) to a key
     * 
     *  @param   _button    The controller button to map
     *  @param   _key       The key to bind to the button
     */
    public function bind_key(button:String, key)
    {
        switch(button)
        {
            case 'DPAD_U': DPAD_U.push(key);
            case 'DPAD_D': DPAD_D.push(key);
            case 'DPAD_L': DPAD_L.push(key);
            case 'DPAD_R': DPAD_R.push(key);
            case 'FACE_A': FACE_A.push(key);
            case 'FACE_B': FACE_B.push(key);
            case 'FACE_X': FACE_X.push(key);
            case 'FACE_Y': FACE_Y.push(key);
            case 'BMPR_L': BMPR_L.push(key);
            case 'BMPR_R': BMPR_R.push(key);
            case 'UTIL_P': UTIL_P.push(key);
            case 'UTIL_M': UTIL_M.push(key);
        }
    }

}