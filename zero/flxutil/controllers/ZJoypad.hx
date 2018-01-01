package zero.flxutil.controllers;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class ZJoypad extends ZBaseController
{

    var pad:FlxGamepad;
    var p:Int;
    var left_analog:AnalogStick;
    var already_alerted:Bool = false;

    public var connected:Bool = false;
    public var connect_timer_interval:Int = 1;
    public var try_to_reconnect:Bool = false;
    public var alert_connected: Void -> Void;
    public var alert_disconnected: Void -> Void;
    public var alert_not_connected: Void -> Void;

    /**
     *  Creates a new Joypad object, and tries to connect to a gamepad
     *  
     *  @param   player Whether or not the controller object creating this is for Player One or not
     */
    public function new(player:Int = 0, ?alert_connected:Void -> Void, ?alert_disconnected:Void -> Void, ?alert_not_connected:Void -> Void)
    {
        super();
        p = player;
        left_analog = new AnalogStick();
        alert_connected == null ?
            this.alert_connected = function () { 
                #if debug
                FlxG.log.add('Controller $p connected!');
                #end
            } :
            this.alert_connected = alert_connected;
        alert_disconnected == null ?
            this.alert_disconnected = function () { 
                #if debug
                FlxG.log.add('Controller $p disconnected!');
                #end
            } :
            this.alert_disconnected = alert_connected;
        alert_not_connected == null ?
            this.alert_not_connected = function () { 
                #if debug
                FlxG.log.add('Controller $p not connected!');
                #end
            } :
            this.alert_not_connected = alert_connected;
        connect();
    }

    function connect(?t:FlxTimer)
    {
        if (pad == null)
            pad = FlxG.gamepads.getActiveGamepads()[p];
        if (pad != null)
        {
            alert_connected();
            connected = true;
            return;
        }
        else if (!already_alerted)
        {
            alert_not_connected();
            already_alerted = true;
        }
        new FlxTimer().start(connect_timer_interval, connect);
    }

    override public function update(e)
    {
        super.update(e);
        
        if (pad == null)
        {
            if (connected)
            {
                connected = false;
                if (try_to_reconnect) connect();
            }

            return;
        }
        
        left_analog.update(pad.analog.value.LEFT_STICK_X, pad.analog.value.LEFT_STICK_Y);

        // DPAD

        state.dpad.u = pad.pressed.DPAD_UP           || left_analog.u;
        state.dpad.d = pad.pressed.DPAD_DOWN         || left_analog.d;
        state.dpad.l = pad.pressed.DPAD_LEFT         || left_analog.l;
        state.dpad.r = pad.pressed.DPAD_RIGHT        || left_analog.r;

        state.dpad.u_p = pad.justPressed.DPAD_UP     || left_analog.u_p;
        state.dpad.d_p = pad.justPressed.DPAD_DOWN   || left_analog.d_p;
        state.dpad.l_p = pad.justPressed.DPAD_LEFT   || left_analog.l_p;
        state.dpad.r_p = pad.justPressed.DPAD_RIGHT  || left_analog.r_p;
        
        state.dpad.u_r = pad.justReleased.DPAD_UP    || left_analog.u_r;
        state.dpad.d_r = pad.justReleased.DPAD_DOWN  || left_analog.d_r;
        state.dpad.l_r = pad.justReleased.DPAD_LEFT  || left_analog.l_r;
        state.dpad.r_r = pad.justReleased.DPAD_RIGHT || left_analog.r_r;

        // FACE

        state.face.a = pad.pressed.A;
        state.face.b = pad.pressed.B;
        state.face.x = pad.pressed.X;
        state.face.y = pad.pressed.Y;

        state.face.a_p = pad.justPressed.A;
        state.face.b_p = pad.justPressed.B;
        state.face.x_p = pad.justPressed.X;
        state.face.y_p = pad.justPressed.Y;

        state.face.a_r = pad.justReleased.A;
        state.face.b_r = pad.justReleased.B;
        state.face.x_r = pad.justReleased.X;
        state.face.y_r = pad.justReleased.Y;

        // SHOULDER

        state.bmpr.l = pad.pressed.LEFT_SHOULDER         || pad.pressed.LEFT_TRIGGER;
        state.bmpr.r = pad.pressed.RIGHT_SHOULDER        || pad.pressed.RIGHT_SHOULDER;

        state.bmpr.l_p = pad.justPressed.LEFT_SHOULDER   || pad.justPressed.LEFT_TRIGGER;
        state.bmpr.r_p = pad.justPressed.RIGHT_SHOULDER  || pad.justPressed.RIGHT_SHOULDER;

        state.bmpr.l_r = pad.justReleased.LEFT_SHOULDER  || pad.justReleased.LEFT_TRIGGER;
        state.bmpr.r_r = pad.justReleased.RIGHT_SHOULDER || pad.justReleased.RIGHT_SHOULDER;

        // UTILITY

        state.util.m = pad.pressed.BACK;
        state.util.p = pad.pressed.START;

        state.util.m_p = pad.justPressed.BACK;
        state.util.p_p = pad.justPressed.START;

        state.util.m_r = pad.justReleased.BACK;
        state.util.p_r = pad.justReleased.START;
    }

    public function set_dead_zone(dead_zone:Float = 0.2)
    {
        left_analog.set_dead_zone(dead_zone);
    }

    public function get_pad():FlxGamepad
    {
        return pad;
    }

    public function get_left_analog_state():FlxPoint
    {
        return FlxPoint.get(left_analog.x, left_analog.y);
    }

}

class AnalogStick 
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

    public var x:Float;
    public var y:Float;

    var previous_x:Float = 0;
    var previous_y:Float = 0;

    var dead_zone:Float = 0.2;

    /**
     *  Creates an object that treats analog inputs as buttons.
     *  
     */
    public function new()
    {

    }

    public function update(x, y)
    {
        this.x = x;
        this.y = y;
        u = false;
        d = false;
        l = false;
        r = false;
        u_p = false;
        d_p = false;
        l_p = false;
        r_p = false;
        u_r = false;
        d_r = false;
        l_r = false;
        r_r = false;

        if (Math.abs(y) > dead_zone)
        {
            if (y < -dead_zone) 
            {
                u = true;
                if (previous_y >= -dead_zone) u_p = true;
            }
            if (y > dead_zone) 
            {
                d = true;
                if (previous_y <= dead_zone) d_p = true;
            }
        }
        else if (Math.abs(previous_y) > dead_zone)
        {
            if (previous_y < -dead_zone) u_r = true;
            if (previous_y > dead_zone) d_r = true;
        }

        if (Math.abs(x) > dead_zone)
        {
            if (x < -dead_zone) 
            {
                l = true;
                if (previous_x >= -dead_zone) l_p = true;
            }
            if (x > dead_zone) 
            {
                r = true;
                if (previous_x <= dead_zone) r_p = true;
            }
        }
        else if (Math.abs(previous_x) > dead_zone)
        {
            if (previous_x < -dead_zone) l_r = true;
            if (previous_x > dead_zone) r_r = true;
        }

        previous_x = x;
        previous_y = y;
    }

    /**
     *  Sets the deadzone for analog inputs
     *  
     *  @param   dead_zone (0-1) The point at which the analog input is considered to be a button down event
     */
    public function set_dead_zone(dead_zone:Float)
    {
        this.dead_zone = dead_zone;
    }

}