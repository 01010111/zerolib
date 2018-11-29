package zero.flxutil.sprites;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using Math;
using zero.ext.FloatExt;
using zero.ext.flx.FlxPointExt;

class Stack extends FlxSprite
{

	var group:StackGroup;
	var options:StackOptions;
	var slice_post_init:FlxSprite -> Void = function(_){};

	public var z_offset:Float;
	
	public function new(options:StackOptions)
	{
		super(options.position.x, options.position.y);
		if (options.camera == null) options.camera = FlxG.camera;
		this.z_offset = options.z_offset;
		this.options = options;
		init();
	}

	function init()
	{
		init_group();
		add_to_groups();
		for (i in 0...options.slices) init_slice(i == 0 ? this : new FlxSprite(), i);
	}


	function init_group()
	{
		group = new StackGroup(this, options.camera);
		group.camera = options.camera;
	}

	function add_to_groups()
	{
		StackManager.i.base_group.add(this);
		StackManager.i.object_group.add(group);
	}

	function init_slice(slice:FlxSprite, i:Int)
	{
		slice.loadGraphic(options.graphic, true, options.frame_width, options.frame_height);
		slice.animation.frameIndex = i;
		if (options.offset != null) slice.offset.copyFrom(options.offset);
		if (options.size != null) slice.setSize(options.size.x, options.size.y);
		group.add(slice);
		slice_post_init(slice);
	}

	public function add(state:FlxState) state.add(group);

	override public function update(dt:Float)
	{
		super.update(dt);
		set_slices();
	}

	function set_slices()
	{
		var offset:FlxPoint = ((options.camera.angle + 90) * -1).flxpoint_from_angle(z_offset);
		for (i in 1...group.members.length) set_slice(group.members[i], offset, i);
	}

	function set_slice(slice:FlxSprite, offset:FlxPoint, i:Int)
	{
		slice.setPosition(x + offset.x * i, y + offset.y * i);
		slice.angle = angle;
	}

	public function combine(stack:Stack)
	{
		StackManager.i.base_group.remove(stack);
		StackManager.i.object_group.remove(stack.group);
		for (slice in stack.group) group.add(slice);
	}
	
}

class StackGroup extends FlxTypedGroup<FlxSprite>
{

	public var z(get, never):Float;
	function get_z():Float
	{
		return (base.getMidpoint().vector_angle() + cam.angle).vector_from_angle(base.getPosition().vector_length()).y;
	}

	var base:FlxSprite;
	var cam:FlxCamera;

	public function new(base:FlxSprite, camera:FlxCamera)
	{
		this.base = base;
		this.cam = camera;
		super();
	}

}

class StackManager
{

	public static var i:StackManager;

	public var base_group:FlxTypedGroup<Stack> = new FlxTypedGroup();
	public var object_group:FlxTypedGroup<StackGroup> = new FlxTypedGroup();

	public function new() i = this;

	public function init_camera(camera:FlxCamera, size:Int = 0)
	{
		if (size <= 0) size = (FlxG.width.pow(2) + FlxG.height.pow(2)).sqrt().ceil();
		camera.setSize(size, size);
		camera.setPosition((FlxG.width - size) * 0.5, (FlxG.height - size) * 0.5);
		camera.scroll.set(camera.x, camera.y);
	}

	public function sort_objects() object_group.sort(function(order:Int, g1:StackGroup, g2:StackGroup) return g1.z > g2.z ? 1 : -1, 0);
	public function adjust_tilt(amt:Float) for (stack in base_group) stack.z_offset += amt;

}

typedef StackOptions =
{
	position:FlxPoint,
	graphic:String,
	slices:Int,
	frame_height:Int,
	frame_width:Int,
	z_offset:Float,
	?size:FlxPoint,
	?offset:FlxPoint,
	?camera:FlxCamera,
}