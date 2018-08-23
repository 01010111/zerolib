package zero.flxutil.ui;

import flixel.addons.ui.FlxSlider;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import zero.flxutil.util.GameLog.*;
import zero.util.IntPoint;

using flixel.util.FlxSpriteUtil;
using zero.ext.FloatExt;
using zero.ext.flx.FlxSpriteExt;
using Math;

class NineSliceBox extends FlxSprite
{

	var width_in_tiles:Int;
	var height_in_tiles:Int;
	var stamp_graphic:FlxGraphicAsset;
	var slice_size:SliceSize;
	var default_data = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
		[0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
		[0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
		[0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	];

	/**
	 *  Creates a box of a given size consisting of 9 tiles
	 *  
	 *  @param   options NineSliceOptions
	 */
	public function new(options:NineSliceOptions)
	{
		super();
		if (options.position != null) setPosition(options.position.x, options.position.y);
		stamp_graphic = options.graphic == null ? make_default_graphic() : options.graphic.graphic;
		slice_size = options.graphic == null ? { width: 8, height: 8 } : options.graphic.slice_size;
		options.scroll_factor == null ? scrollFactor.set() : scrollFactor.copyFrom(options.scroll_factor);
		width_in_tiles = (options.size.x / slice_size.width).floor();
		height_in_tiles = (options.size.y / slice_size.height).floor();
		stamp_nine_tile(width_in_tiles, height_in_tiles);
	}

	function make_default_graphic():BitmapData
	{
		var bd = new BitmapData(24, 24, false, 0x000000);
		for (j in 0...24) for (i in 0...24) if (default_data[j][i] == 1) bd.setPixel(i, j, 0xFFFFFF);
		return bd;
	}

	function stamp_nine_tile(w:Int, h:Int)
	{
		makeGraphic(width_in_tiles * slice_size.width, height_in_tiles * slice_size.height, 0x00FFFFFF, true);
		var s = new FlxSprite();
		s.loadGraphic(stamp_graphic, true, slice_size.width, slice_size.height);
		for (i in 0...w)
		{
			for (j in 0...h)
			{
				s.animation.frameIndex = find_stamp_frame(i, j, w, h);
				stamp(s, i * slice_size.width, j * slice_size.height);
			}
		}
	}

	function find_stamp_frame(i, j, w, h):Int
	{
		if (j == 0)						return find_stamp_frame_hor(i, w, 0);
		else if (j == h - 1)			return find_stamp_frame_hor(i, w, 6);
		else							return find_stamp_frame_hor(i, w, 3);
	}

	function find_stamp_frame_hor(i, w, o):Int
	{
		if (i == 0)				return 0 + o;
		else if (i == w - 1)	return 2 + o;
		else					return 1 + o;
	}

}

typedef NineSliceOptions =
{
	size:FlxPoint,
	?graphic:NineSliceGraphic,
	?position:FlxPoint,
	?scroll_factor:FlxPoint,
}

typedef NineSliceGraphic =
{
	graphic:FlxGraphicAsset,
	slice_size:SliceSize,
}

typedef SliceSize =
{
	width:Int,
	height:Int
}