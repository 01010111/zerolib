package zero.flxutil.controllers;

import flixel.FlxG;
import flixel.FlxBasic;

/**
 *  @author 01010111 
 */
class ZBaseController extends FlxBasic
{

    public var state:ControllerState;

    /**
     *  Creates a new controller object
     *  
     */
    public function new()
    {
        super();
        state = new ControllerState();
    }

    /**
     *  Adds the controller to stage.
     *  IMPORTANT! This will force flixel to update the controller!
     */
    public function add()
    {
        FlxG.state.add(this);
    }

    /**
     *  For Debugging purposes. Adds variables to FlxDebugger's watch list
     *  
     *  @param   _dpad              Whether or not to add DPAD button inputs to the watch list
     *  @param   _face              Whether or not to add Face button inputs to the watch list
     *  @param   _bmpr              Whether or not to add Shoulder button inputs to the watch list
     *  @param   _util              Whether or not to add Utility button inputs to the watch list
     *  @param   _pressed           Whether or not to watch for pressed events
     *  @param   _just_pressed      Whether or not to watch for just pressed events
     *  @param   _just_released     Whether or not to watch for just released events
     */
    public function add_inputs_to_watch(
        _dpad:Bool = true, 
        _face:Bool = true, 
        _bmpr:Bool = true,
        _util:Bool = true,
        _pressed:Bool = true,
        _just_pressed:Bool = false,
        _just_released:Bool = false
    )
    {
        if (_dpad)
        {
            if (_pressed)
            {
                FlxG.watch.add(state.dpad, 'u', 'DPAD_UP: ');
                FlxG.watch.add(state.dpad, 'd', 'DPAD_DOWN: ');
                FlxG.watch.add(state.dpad, 'l', 'DPAD_LEFT: ');
                FlxG.watch.add(state.dpad, 'r', 'DPAD_RIGHT: ');
            }
            if (_just_pressed)
            {
                FlxG.watch.add(state.dpad, 'u_p', 'DPAD_UP_P: ');
                FlxG.watch.add(state.dpad, 'd_p', 'DPAD_DOWN_P: ');
                FlxG.watch.add(state.dpad, 'l_p', 'DPAD_LEFT_P: ');
                FlxG.watch.add(state.dpad, 'r_p', 'DPAD_RIGHT_P: ');
            }
            if (_just_released)
            {
                FlxG.watch.add(state.dpad, 'u_r', 'DPAD_UP_R: ');
                FlxG.watch.add(state.dpad, 'd_r', 'DPAD_DOWN_R: ');
                FlxG.watch.add(state.dpad, 'l_r', 'DPAD_LEFT_R: ');
                FlxG.watch.add(state.dpad, 'r_r', 'DPAD_RIGHT_R: ');
            }
        }

        if (_face)
        {
            if (_pressed)
            {
                FlxG.watch.add(state.face, 'a', 'FACE_A: ');
                FlxG.watch.add(state.face, 'b', 'FACE_B: ');
                FlxG.watch.add(state.face, 'x', 'FACE_X: ');
                FlxG.watch.add(state.face, 'y', 'FACE_Y: ');
            }
            if (_just_pressed)
            {
                FlxG.watch.add(state.face, 'a_p', 'FACE_A_P: ');
                FlxG.watch.add(state.face, 'b_p', 'FACE_B_P: ');
                FlxG.watch.add(state.face, 'x_p', 'FACE_X_P: ');
                FlxG.watch.add(state.face, 'y_p', 'FACE_Y_P: ');
            }
            if (_just_released)
            {
                FlxG.watch.add(state.face, 'a_r', 'FACE_A_R: ');
                FlxG.watch.add(state.face, 'b_r', 'FACE_B_R: ');
                FlxG.watch.add(state.face, 'x_r', 'FACE_X_R: ');
                FlxG.watch.add(state.face, 'y_r', 'FACE_Y_R: ');
            }
        }

        if (_bmpr)
        {
            if (_pressed)
            {
                FlxG.watch.add(state.bmpr, 'l', 'BMPR_L: ');
                FlxG.watch.add(state.bmpr, 'r', 'BMPR_R: ');
            }
            if (_just_pressed)
            {
                FlxG.watch.add(state.bmpr, 'l_p', 'BMPR_L_P: ');
                FlxG.watch.add(state.bmpr, 'r_p', 'BMPR_R_P: ');
            }
            if (_just_released)
            {
                FlxG.watch.add(state.bmpr, 'l_r', 'BMPR_L_R: ');
                FlxG.watch.add(state.bmpr, 'r_r', 'BMPR_R_R: ');
            }
        }
    }

}

class ControllerState
{
    public var dpad:DPadBtns;
    public var face:FaceBtns;
    public var bmpr:BmprBtns;
    public var util:UtilBtns;

    /**
     *  Keeps track of the state of all possible buttons.
     *  
     */
    public function new()
    {
        dpad = new DPadBtns();
        face = new FaceBtns();
        bmpr = new BmprBtns();
        util = new UtilBtns();
    }
}

class DPadBtns
{
    public var u:Bool = false;
    public var d:Bool = false;
    public var l:Bool = false;
    public var r:Bool = false;

    public var u_p:Bool = false;
    public var d_p:Bool = false;
    public var l_p:Bool = false;
    public var r_p:Bool = false;

    public var u_r:Bool = false;
    public var d_r:Bool = false;
    public var l_r:Bool = false;
    public var r_r:Bool = false;

    /**
     *  Keeps track of DPad buttons - up, down, left, and right
     *  
     */
    public function new()
    {

    }
}

class FaceBtns
{
    public var a:Bool = false;
    public var b:Bool = false; 
    public var x:Bool = false;
    public var y:Bool = false;

    public var a_p:Bool = false;
    public var b_p:Bool = false;
    public var x_p:Bool = false;
    public var y_p:Bool = false;

    public var a_r:Bool = false;
    public var b_r:Bool = false;
    public var x_r:Bool = false;
    public var y_r:Bool = false;

    /**
     *  Keeps track of Face buttons - A, B, X, and Y
     *  
     */
    public function new()
    {

    }
}

class BmprBtns
{
    public var l:Bool = false;
    public var r:Bool = false;

    public var l_p:Bool = false;
    public var r_p:Bool = false;

    public var l_r:Bool = false;
    public var r_r:Bool = false;

    /**
     *  Keeps track of Shoulder Buttons - L, and R
     *  
     */
    public function new()
    {

    }
}

class UtilBtns
{
    public var p:Bool = false;
    public var m:Bool = false;

    public var p_p:Bool = false;
    public var m_p:Bool = false;

    public var p_r:Bool = false;
    public var m_r:Bool = false;

    /**
     *  Keeps track of utility buttons - Pause, and Map
     *  
     */
    public function new()
    {

    }
}