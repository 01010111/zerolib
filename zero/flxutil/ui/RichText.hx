package zero.flxutil.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import zero.util.IntPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import zero.flxutil.sprites.ParticleEmitter.Particle;

using Math;
using StringTools;
using zero.ext.FloatExt;

class RichText extends FlxTypedGroup<RichTextChar>
{

	var anim_options:RichTextAnimOptions;
	var graphic_options:RichTextGraphicOptions;
	var queued_text:Array<String>;
	var queued_strings:Array<String> = [];
	var cursor_position:IntPoint;
	var timer:Float;
	var position:FlxPoint;
	var text_field_options:RichTextFieldOptions;
	var current_effects:Array<ERichTextCharEffect> = [];
	var current_color:Int;
	var state:ERichTextState;
	var override_type_effect:Bool = false;
	var wiggle_timer:Float = 0;

	public function new(options:RichTextOptions)
	{
		super();
		options = create_defaults(options);
		position = options.position;
		anim_options = options.animations;
		graphic_options = options.graphic_options;
		text_field_options = options.text_field_options;
		queued_strings = options.queued_strings == null ? [] : options.queued_strings;
		state = queued_strings.length == 0 ? EMPTY : READY;
		FlxG.watch.add(this, 'wiggle_timer', 'WT:');
	}

	public function create_defaults(options:RichTextOptions)
	{
		if (options.position == null) options.position = FlxPoint.get(0, 0);
		
		if (options.text_field_options == null) options.text_field_options = {};
		if (options.text_field_options.line_spacing == null) options.text_field_options.line_spacing = 0;
		if (options.text_field_options.letter_spacing == null) options.text_field_options.letter_spacing = 0;
		if (options.text_field_options.field_width == null) options.text_field_options.field_width = FlxG.width;
		if (options.text_field_options.field_height == null) options.text_field_options.field_height = FlxG.height;

		if (options.animations == null) options.animations = {};
		if (options.animations.build_in == null) options.animations.build_in = {
			effect: NONE,
			ease: LINEAR,
			speed: 0,
			amount: 0
		};
		if (options.animations.build_out == null) options.animations.build_out = {
			effect: NONE,
			ease: LINEAR,
			speed: 0,
			amount: 0
		};
		if (options.animations.shake_options == null) options.animations.shake_options = {
			speed: 0.05,
			amount: 3
		};
		if (options.animations.wiggle_options == null) options.animations.wiggle_options = {
			speed: 0.25,
			frequency: 128,
			amount: 2
		};
		if (options.animations.type_effect == null) options.animations.type_effect = {
			rate: 0.03,
			effect: TYPEWRITER
		};

		return options;
	}

	public function get_anim_options():RichTextAnimOptions return anim_options;
	public function get_current_color():Int return current_color;
	public function get_wiggle_timer():Float return wiggle_timer;

	public function queue(s:String)
	{
		if (s.length == 0) return;
		var s_parsed = parse_input(s);
		for (string in s_parsed) queued_strings.push(string);
		state = READY;
	}

	public function parse_input(s:String):Array<String>
	{	
		var out = [];
		var temp_s = parse_new_line_chars(remove_unavailable_characters(s));
		var words = temp_s.split(' ');
		var w = 0;
		var h = 0;
		var max_w = (text_field_options.field_width / (graphic_options.frame_width + text_field_options.letter_spacing)).floor();
		var max_h = (text_field_options.field_height / (graphic_options.frame_height + text_field_options.line_spacing)).floor();
		var out_words = [];
		for (word in words)
		{
			var has_command = false;
			for (cmd in ['<w>', '</w>', '<c#', '</c>', '<s>', '</s>']) if (word.indexOf(cmd) >= 0) has_command = true;
			var len = has_command ? get_special_word_length(word) + 1 : word.length + 1;
			w += len;
			if (word.indexOf('\n') >= 0)
			{
				w = len;
				h ++;
				if (h > max_h)
				{
					out.push(out_words.join(' '));
					out_words = [];
					h = 0;
				}
			}
			if (w > max_w)
			{
				w = len;
				h ++;
				if (h > max_h)
				{
					out.push(out_words.join(' '));
					out_words = [];
					h = 0;
				}
				else word = '\n$word';
			}
			out_words.push(word);
		}
		out.push(out_words.join(' '));
		return out;
	}

	function get_special_word_length(word:String)
	{
		var do_add = true;
		var amt = 0;
		for (i in 0...word.length)
		{
			var char = word.charAt(i);
			if (char == '<') do_add = false;
			else if (do_add) amt++;
			else if (!do_add && char == '>') do_add = true;
		}
		return amt;
	}

	function remove_unavailable_characters(s:String):String
	{
		var protected = ' \n</>';
		var temp_s = '';
		for (i in 0...s.length) if (graphic_options.charset.indexOf(s.charAt(i)) >= 0 || protected.indexOf(s.charAt(i)) >= 0) temp_s += s.charAt(i);
		return temp_s;
	}

	function parse_new_line_chars(s:String):String
	{
		if (s.indexOf('\n') < 0) return s;
		var lines = s.split('\n');
		for (i in 0...lines.length) lines[i] = lines[i].trim();
		for (i in 1...lines.length) lines[i] = '\n${lines[i]}';
		return lines.join(' ');
	}

	public function invoke():Bool
	{
		switch (state)
		{
			case EMPTY: return false;
			case READY: 
				state = TYPING;
				cursor_position = new IntPoint();
				queued_text = queued_strings.shift().split('');
				return true;
			case TYPING:
				override_type_effect = true;
				return true;
			case COMPLETE:
				state = queued_strings.length > 0 ? READY : EMPTY;
				for (char in members) char.dismiss();
				state == EMPTY ? return false : {
					state = TYPING;
					cursor_position = new IntPoint();
					queued_text = queued_strings.shift().split('');
					return true;
				}
		}
	}

	override public function update(dt)
	{
		wiggle_timer = (wiggle_timer + dt) % 1;
		super.update(dt);
		switch (state)
		{
			case EMPTY, READY, COMPLETE: return;
			case TYPING:
				if (queued_text == null || queued_text.length == 0) state = COMPLETE;
				if (state == TYPING) typing(dt);
		}
	}

	function typing(dt)
	{
		if (override_type_effect)
		{
			while (queued_text.length > 0) type_out(dt, true);
			override_type_effect = false;
			return;
		}
		switch (anim_options.type_effect.effect)
		{
			case IMMEDIATE: while (queued_text.length > 0) type_out(dt, true);
			case TYPEWRITER: type_out(dt);
		}
	}

	function type_out(dt, ignore_timer:Bool = false)
	{
		if (!timer_trigger(dt) && !ignore_timer) return;
		check_effects();
		post_char(queued_text.shift());
	}

	function check_effects()
	{
		if (queued_text[0] != '<') return;
		var is_cmd = false;
		for (cmd in ['/', 'w', 'c', 's']) if (queued_text[1] == cmd) is_cmd = true;
		if (!is_cmd) return;
		var mode = queued_text[1] == '/' ? REMOVE : ADD;
		switch (mode) {
			case ADD: add_effect();
			case REMOVE: remove_effect();
		}
	}

	function add_effect()
	{
		switch (queued_text[1])
		{
			case 'w': 
				if (current_effects.indexOf(WIGGLE) < 0) current_effects.push(WIGGLE);
				for (i in 0...3) queued_text.shift();
			case 's': 
				if (current_effects.indexOf(WIGGLE) < 0) current_effects.push(SHAKE);
				for (i in 0...3) queued_text.shift();
			case 'c': 
				if (current_effects.indexOf(WIGGLE) < 0) current_effects.push(COLOR);
				current_color = Std.parseInt('0xFF${[for (i in 3...9) queued_text[i]].join('')}');
				for (i in 0...10) queued_text.shift();
		}
	}

	function remove_effect()
	{
		switch (queued_text[2])
		{
			case 'w': current_effects.remove(WIGGLE);
			case 'c': current_effects.remove(COLOR);
			case 's': current_effects.remove(SHAKE);
			default: return;
		}
		for (i in 0...4) queued_text.shift();
	}

	function timer_trigger(dt:Float):Bool
	{
		timer -= dt;
		if (timer > 0) return false;
		timer = anim_options.type_effect.rate;
		return true;
	}

	function post_char(char:String)
	{
		if (char == null) return;
		if (char == '\n')
		{
			cursor_position.x = 0;
			cursor_position.y++;
			return;
		}
		if (char == ' ')
		{
			cursor_position.x++;
			return;
		}
		while (getFirstAvailable() == null) add(new RichTextChar(this, graphic_options));
		getFirstAvailable().post(
			char,
			FlxPoint.get().copyFrom(position).add(
				cursor_position.x * (graphic_options.frame_width + text_field_options.letter_spacing),
				cursor_position.y * (graphic_options.frame_height + text_field_options.line_spacing)
			),
			anim_options.build_in,
			anim_options.build_out,
			current_effects
		);
		cursor_position.x++;
	}

}

class RichTextChar extends Particle
{

	var charset:String;
	var build_in:RichTextBuildInOptions;
	var build_out:RichTextBuildOutOptions;
	var effects:Array<ERichTextCharEffect>;
	var wiggle_tween:FlxTween;
	var build_tween:FlxTween;
	var shake:Bool = false;
	var shake_amt:Float;
	var shake_timer:Float;
	var emitter:RichText;

	public function new(emitter:RichText, options:RichTextGraphicOptions)
	{
		super();
		loadGraphic(options.graphic, true, options.frame_width, options.frame_height);
		charset = options.charset;
		for (i in 0...charset.length) animation.add(charset.charAt(i), [i]);
		this.emitter = emitter;
	}

	public function post(char:String, position:FlxPoint, build_in:RichTextBuildInOptions, build_out:RichTextBuildOutOptions, effects:Array<ERichTextCharEffect>)
	{
		if (char == null) return;
		apply_effect(NONE);
		reset(position.x, position.y);
		animation.play(char);
		this.build_in = {
			effect: build_in.effect,
			ease: build_in.ease,
			speed: build_in.speed,
			amount: build_in.amount,
		};
		this.build_out = {
			speed: build_out.speed,
			effect: build_out.effect,
			ease: build_out.ease,
			amount: build_out.amount
		};
		for (effect in effects) apply_effect(effect);
		apply_build_in_effect(this.build_in);
	}

	function apply_effect(effect:ERichTextCharEffect)
	{
		switch (effect)
		{
			case NONE:
				offset.set();
				color = 0xFFFFFFFF;
				shake = false;
				if (wiggle_tween != null) wiggle_tween.cancel();
			case WIGGLE:
				if (build_in.effect == FADE_IN_FROM_TOP || build_in.effect == FADE_IN_FROM_BOTTOM) build_in.effect = FADE_IN;
				y -= emitter.get_anim_options().wiggle_options.amount.half();
				wiggle_tween = FlxTween.tween(this, { y: y + emitter.get_anim_options().wiggle_options.amount }, emitter.get_anim_options().wiggle_options.speed, { ease: FlxEase.sineInOut, type:FlxTweenType.PINGPONG });
				wiggle_tween.percent = (x + emitter.get_wiggle_timer()) % emitter.get_anim_options().wiggle_options.frequency;
			case SHAKE:
				shake = true;
				shake_amt = emitter.get_anim_options().shake_options.amount;
			case COLOR: color = emitter.get_current_color();
		}
	}

	function apply_build_in_effect(options:RichTextBuildInOptions)
	{
		alpha = 0;
		scale.set(1, 1);
		switch (options.effect)
		{
			case NONE: alpha = 1;
			case FADE_IN: build_tween = FlxTween.tween(this, { alpha: 1 }, options.speed, { ease: get_ease_out(options.ease) });
			case FADE_IN_FROM_TOP:
				y -= options.amount;
				build_tween = FlxTween.tween(this, { alpha: 1, y: y + options.amount }, options.speed, { ease: get_ease_out(options.ease) });
			case FADE_IN_FROM_BOTTOM:
				y += options.amount;
				build_tween = FlxTween.tween(this, { alpha: 1, y: y - options.amount }, options.speed, { ease: get_ease_out(options.ease) });
			case FADE_IN_FROM_LEFT:
				x -= options.amount;
				build_tween = FlxTween.tween(this, { alpha: 1, x: x + options.amount }, options.speed, { ease: get_ease_out(options.ease) });
			case FADE_IN_FROM_RIGHT:
				x += options.amount;
				build_tween = FlxTween.tween(this, { alpha: 1, x: x - options.amount }, options.speed, { ease: get_ease_out(options.ease) });
			case SCALE_IN: 
				alpha = 1;
				scale.set();
				build_tween = FlxTween.tween(scale, { x: 1, y: 1 }, options.speed, { ease: get_ease_out(options.ease) });
		}
	}

	public function dismiss()
	{
		apply_build_out_effect(build_out);
	}

	function apply_build_out_effect(options:RichTextBuildOutOptions)
	{
		switch (options.effect)
		{
			case NONE: kill();
			case FADE_OUT: 				build_tween = FlxTween.tween(this, { alpha: 0 }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
			case FADE_OUT_TO_TOP: 		build_tween = FlxTween.tween(this, { alpha: 0, y: y - options.amount }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
			case FADE_OUT_TO_BOTTOM:	build_tween = FlxTween.tween(this, { alpha: 0, y: y + options.amount }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
			case FADE_OUT_TO_LEFT:		build_tween = FlxTween.tween(this, { alpha: 0, x: x - options.amount }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
			case FADE_OUT_TO_RIGHT:		build_tween = FlxTween.tween(this, { alpha: 0, x: x + options.amount }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
			case SCALE_OUT:				build_tween = FlxTween.tween(scale, { x: 0, y: 0 }, options.speed, { ease: get_ease_in(options.ease), onComplete: function(_) { kill(); } });
		}
	}

	function get_ease_in(ease_type:ERichTextTransitionEase)
	{
		return switch (ease_type) {
			case LINEAR:	FlxEase.linear;
			case SINE:		FlxEase.sineIn;
			case BACK:		FlxEase.backIn;
			case ELASTIC:	FlxEase.elasticIn;
		}
	}

	function get_ease_out(ease_type:ERichTextTransitionEase)
	{
		return switch (ease_type) {
			case LINEAR:	FlxEase.linear;
			case SINE:		FlxEase.sineOut;
			case BACK:		FlxEase.backOut;
			case ELASTIC:	FlxEase.elasticOut;
		}
	}

	override public function update(dt)
	{
		super.update(dt);
		if (shake) do_shake(dt);
	}

	function do_shake(dt:Float)
	{
		if (!shake_timer_trigger(dt)) return;
		var amt = emitter.get_anim_options().shake_options.amount.half();
		offset.set(amt.get_random(-amt), amt.get_random(-amt));
	}

	function shake_timer_trigger(dt:Float):Bool
	{
		shake_timer -= dt;
		if (shake_timer > 0) return false;
		shake_timer = emitter.get_anim_options().shake_options.speed;
		return true;
	}

}

typedef RichTextOptions =
{
	graphic_options:RichTextGraphicOptions,
	?position:FlxPoint,
	?animations:RichTextAnimOptions,
	?text_field_options:RichTextFieldOptions,
	?queued_strings:Array<String>,
}

typedef RichTextGraphicOptions =
{
	graphic:FlxGraphicAsset,
	frame_width:Int,
	frame_height:Int,
	charset:String,
}

typedef RichTextAnimOptions =
{
	?build_in:RichTextBuildInOptions,
	?build_out:RichTextBuildOutOptions,
	?type_effect:RichTextTypeEffectOptions,
	?wiggle_options:RichTextWiggleOptions,
	?shake_options:RichTextShakeOptions,
}

typedef RichTextFieldOptions =
{
	?line_spacing:Float,
	?letter_spacing:Float,
	?field_width:Int,
	?field_height:Int,
}

typedef RichTextBuildInOptions =
{
	effect:ERichTextBuildInEffect,
	ease:ERichTextTransitionEase,
	speed:Float,
	amount:Float,
}

typedef RichTextBuildOutOptions =
{
	effect:ERichTextBuildOutEffect,
	ease:ERichTextTransitionEase,
	speed:Float,
	amount:Float,
}

typedef RichTextTypeEffectOptions =
{
	effect:ERichTextTypeEffect,
	rate:Float,
}

typedef RichTextWiggleOptions =
{
	amount:Float,
	speed:Float,
	frequency:Float,
}

typedef RichTextShakeOptions =
{
	amount:Float,
	speed:Float,
}

typedef RichTextCharOptions =
{
	position:FlxPoint,
	character:String,
	effects:Array<ERichTextCharEffect>,
}

enum ERichTextBuildInEffect
{
	NONE;
	FADE_IN;
	FADE_IN_FROM_TOP;
	FADE_IN_FROM_BOTTOM;
	FADE_IN_FROM_LEFT;
	FADE_IN_FROM_RIGHT;
	SCALE_IN;
}

enum ERichTextBuildOutEffect
{
	NONE;
	FADE_OUT;
	FADE_OUT_TO_TOP;
	FADE_OUT_TO_BOTTOM;
	FADE_OUT_TO_LEFT;
	FADE_OUT_TO_RIGHT;
	SCALE_OUT;
}

enum ERichTextTransitionEase
{
	LINEAR;
	SINE;
	BACK;
	ELASTIC;
}

enum ERichTextTypeEffect
{
	IMMEDIATE;
	TYPEWRITER;
}

enum ERichTextCharEffect
{
	NONE;
	WIGGLE;
	SHAKE;
	COLOR;
}

enum EEffectParseMode
{
	ADD;
	REMOVE;
}

enum ERichTextState
{
	READY;
	TYPING;
	COMPLETE;
	EMPTY;
}