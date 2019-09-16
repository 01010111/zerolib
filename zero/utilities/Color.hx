package zero.utilities;

using Math;
using StringTools;

/**
 * A color abstract of Vec4
 * 
 * **Usage:**
 * 
 * - Initialize using Color.get() `var color = Color.get(1, 0, 0, 1); // red`
 * - Or with an array `var color:Color = [0, 1, 0, 1]; // green`
 * - Or using a 32 bit Integer `var color = Color.get().from_int32(0xFF0000FF); // blue`
 * - Get/set various details like `color.hue`, `color.saturation`, and more
 * - Swizzle like you're using GLSL! `var yellow = red.rrba;`
 * - Register and use colors in a global palette `Color.PALETTE.set('pico 8 red', Color.get().from_int32(0xFFFF004D));` / `var red = Color.PALETTE['pico 8 red'];`
 * - Recycle colors when you're done with them: `my_color.put()`
 */
@:forward
abstract Color(Vec4)
{

	public static var RED:Color = [1, 0, 0, 1];
	public static var YELLOW:Color = [1, 1, 0, 1];
	public static var GREEN:Color = [0, 1, 0, 1];
	public static var CYAN:Color = [0, 1, 1, 1];
	public static var BLUE:Color = [0, 0, 1, 1];
	public static var MAGENTA:Color = [1, 0, 1, 1];
	public static var WHITE:Color = [1, 1, 1, 1];
	public static var BLACK:Color = [0, 0, 0, 1];
	public static var TRANSPARENT:Color = [1, 1, 1, 0];
	public static var GREY:Color = [0.5, 0.5, 0.5, 1];

	@:dox(hide) public static var PICO_8_BLACK:Color = [0, 0, 0, 1];
	@:dox(hide) public static var PICO_8_DARK_BLUE:Color = [29/255, 43/255, 83/255, 1];
	@:dox(hide) public static var PICO_8_DARK_PURPLE:Color = [126/255, 37/255, 83/255, 1];
	@:dox(hide) public static var PICO_8_DARK_GREEN:Color = [0, 135/255, 81/255, 1];
	@:dox(hide) public static var PICO_8_BROWN:Color = [171/255, 82/255, 54/255, 1];
	@:dox(hide) public static var PICO_8_DARK_GREY:Color = [95/255, 87/255, 79/255, 1];
	@:dox(hide) public static var PICO_8_LIGHT_GREY:Color = [194/255, 195/255, 199/255, 1];
	@:dox(hide) public static var PICO_8_WHITE:Color = [1, 241/255, 232/255, 1];
	@:dox(hide) public static var PICO_8_RED:Color = [1, 0, 77/255, 1];
	@:dox(hide) public static var PICO_8_ORANGE:Color = [1, 163/255, 0, 1];
	@:dox(hide) public static var PICO_8_YELLOW:Color = [1, 236/255, 39/255, 1];
	@:dox(hide) public static var PICO_8_GREEN:Color = [0, 228/255, 54/255, 1];
	@:dox(hide) public static var PICO_8_BLUE:Color = [41/255, 173/255, 1, 1];
	@:dox(hide) public static var PICO_8_INDIGO:Color = [131/255, 118/255, 156/255, 1];
	@:dox(hide) public static var PICO_8_PINK:Color = [1, 119/255, 168/255, 1];
	@:dox(hide) public static var PICO_8_PEACH:Color = [1, 204/255, 170/255, 1];
	
	public static var PALETTE:Map<String, Color> = new Map();

	static var epsilon:Float = 1e-8;
	static function zero(n:Float):Float return n.abs() <= epsilon ? 0 : n;

	static var pool:Array<Color> = [];
	public static function get(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1):Color return pool.length > 0 ? pool.shift().set(red, green, blue, alpha) : new Color(red, green, blue, alpha);
	public inline function put()
	{
		pool.push(cast this);
		this = null;
	}

	@:from static function from_array_float(input:Array<Float>) return new Color(input[0], input[1], input[2], input[3]);
	@:from static function from_array_int(input:Array<Int>) return new Color(input[0], input[1], input[2], input[3]);
	@:arrayAccess function arr_set(n:Int, v:Float) n < 0 || n > 3 ? return : this[n] = v;
	@:arrayAccess function arr_get(n:Int):Float return this[n.min(3).max(0).floor()];

	public var red (get, set):Float;
	function get_red() return this.x;
	function set_red(v:Float) return this.x = v.max(0).min(1);

	public var green (get, set):Float;
	function get_green() return this.y;
	function set_green(v:Float) return this.y = v.max(0).min(1);

	public var blue (get, set):Float;
	function get_blue() return this.z;
	function set_blue(v:Float) return this.z = v.max(0).min(1);

	public var alpha (get, set):Float;
	function get_alpha() return this.w;
	function set_alpha(v:Float) return this.w = v.max(0).min(1);

	public var red_int (get, set):Int;
	function get_red_int() return (this.x * 255).round();
	function set_red_int(v)
	{
		this.x = v/255;
		return v;
	}

	public var green_int (get, set):Int;
	function get_green_int() return (this.y * 255).round();
	function set_green_int(v)
	{
		this.y = v/255;
		return v;
	}

	public var blue_int (get, set):Int;
	function get_blue_int() return (this.z * 255).round();
	function set_blue_int(v)
	{
		this.z = v/255;
		return v;
	}

	public var alpha_int (get, set):Int;
	function get_alpha_int() return (this.w * 255).round();
	function set_alpha_int(v)
	{
		this.w = v/255;
		return v;
	}

	public var hue (get, set):Float;
	function get_hue() return (Math.atan2(Math.sqrt(3) * (green - blue), 2 * red - green - blue) != 0) ? ((180 / Math.PI * Math.atan2(Math.sqrt(3) * (green - blue), 2 * red - green - blue)) + 360) % 360 : 0;
	function set_hue(hue:Float)
	{
		set_HSL(hue, saturation, lightness);
		return hue;
	}

	public var saturation(get, set):Float;
	function get_saturation() return (max_color() - min_color()) / brightness;
	function set_saturation(saturation)
	{
		set_HSL(hue, saturation, lightness);
		return saturation;
	}

	public var lightness(get, set):Float;
	function get_lightness() return (max_color() + min_color()) / 2;
	function set_lightness(lightness)
	{
		set_HSL(hue, saturation, lightness);
		return lightness;
	}

	public var brightness(get, set):Float;
	function get_brightness() return max_color();
	function set_brightness(brightness)
	{
		set_HSV(hue, saturation, brightness);
		return brightness;
	}

	function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) this = [x, y, z, w];
	public inline function set(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0):Color
	{
		this[0] = zero(x);
		this[1] = zero(y);
		this[2] = zero(z);
		this[3] = zero(w);
		return cast this;
	}
	inline function max_color():Float return Math.max(red, Math.max(green, blue));
	inline function min_color():Float return Math.min(red, Math.min(green, blue));

	public inline function to_hex():Int return ((alpha * 255).round() & 0xFF) << 24 | ((red * 255).round() & 0xFF) << 16 | ((green * 255).round() & 0xFF) << 8 | ((blue * 255).round() & 0xFF);
	public inline function from_int32(color:Int) return set(((color >> 16) & 0xff) / 255, ((color >> 8) & 0xff) / 255, (color & 0xff) / 255, ((color >> 24) & 0xff) / 255);
	public inline function equals(color:Color) return red == color.red && green == color.green && blue == color.blue && alpha == color.alpha;
	public function toString():String return 'r: $red | g: $green | b: $blue | a: $alpha | #${to_hex().hex()}';
	
	public function set_HSL(h:Float, s:Float, l:Float):Color
	{
		h /= 360;
		set_from_hue(h);
		var C = (1 - (2 * l - 1).abs()) * s;
		return cast (this - 0.5) * C + l;
	}

	public function set_HSV(h:Float, s:Float, v:Float):Color
	{
		set_from_hue(hue);
		red = ((red - 1) * s + 1) * v;
		green = ((green - 1) * s + 1) * v;
		blue = ((blue - 1) * s + 1) * v;
		return cast this;
	}

	public function set_from_hue(hue:Float):Color
	{
		red = (hue * 6 - 3).abs() - 1;
    	green = 2 - (hue * 6 - 2).abs();
    	blue = 2 - (hue * 6 - 4).abs();
		return cast this;
	}

	@:op(A + B) static function add(v1:Color, v2:Color):Color return Color.get(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
	@:op(A + B) static function add_f(v:Color, n:Float):Color return Color.get(v.x + n, v.y + n, v.z + n, v.w + n);
	@:op(A - B) static function subtract(v1:Color, v2:Color):Color return Color.get(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
	@:op(A - B) static function subtract_f(v:Color, n:Float):Color return Color.get(v.x - n, v.y - n, v.z - n, v.w - n);
	@:op(A * B) static function multiply(v1:Color, v2:Color):Color return Color.get(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z, v1.w * v2.w);
	@:op(A * B) static function multiply_f(v:Color, n:Float):Color return Color.get(v.x * n, v.y * n, v.z * n, v.w * n);
	@:op(A / B) static function divide(v1:Color, v2:Color):Color return Color.get(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z, v1.w / v2.w);
	@:op(A / B) static function divide_f(v:Color, n:Float):Color return Color.get(v.x / n, v.y / n, v.z / n, v.w / n);
	@:op(A % B) static function mod(v1:Color, v2:Color):Color return Color.get(v1.x % v2.x, v1.y % v2.y, v1.z % v2.z, v1.w % v2.w);
	@:op(A % B) static function mod_f(v:Color, n:Float):Color return Color.get(v.x % n, v.y % n, v.z % n, v.w % n);

	@:dox(hide) public var rrrr (get, never):Color; private function get_rrrr() return Color.get(red, red, red, red);
	@:dox(hide) public var rrrg (get, never):Color; private function get_rrrg() return Color.get(red, red, red, green);
	@:dox(hide) public var rrrb (get, never):Color; private function get_rrrb() return Color.get(red, red, red,blue);
	@:dox(hide) public var rrra (get, never):Color; private function get_rrra() return Color.get(red, red, red, alpha);
	@:dox(hide) public var rrgr (get, never):Color; private function get_rrgr() return Color.get(red, red, green, red);
	@:dox(hide) public var rrgg (get, never):Color; private function get_rrgg() return Color.get(red, red, green, green);
	@:dox(hide) public var rrgb (get, never):Color; private function get_rrgb() return Color.get(red, red, green,blue);
	@:dox(hide) public var rrga (get, never):Color; private function get_rrga() return Color.get(red, red, green, alpha);
	@:dox(hide) public var rrbr (get, never):Color; private function get_rrbr() return Color.get(red, red, blue, red);
	@:dox(hide) public var rrbg (get, never):Color; private function get_rrbg() return Color.get(red, red, blue, green);
	@:dox(hide) public var rrbb (get, never):Color; private function get_rrbb() return Color.get(red, red, blue,blue);
	@:dox(hide) public var rrba (get, never):Color; private function get_rrba() return Color.get(red, red, blue, alpha);
	@:dox(hide) public var rrar (get, never):Color; private function get_rrar() return Color.get(red, red, alpha, red);
	@:dox(hide) public var rrag (get, never):Color; private function get_rrag() return Color.get(red, red, alpha, green);
	@:dox(hide) public var rrab (get, never):Color; private function get_rrab() return Color.get(red, red, alpha,blue);
	@:dox(hide) public var rraa (get, never):Color; private function get_rraa() return Color.get(red, red, alpha, alpha);
	@:dox(hide) public var rgrr (get, never):Color; private function get_rgrr() return Color.get(red, green, red, red);
	@:dox(hide) public var rgrg (get, never):Color; private function get_rgrg() return Color.get(red, green, red, green);
	@:dox(hide) public var rgrb (get, never):Color; private function get_rgrb() return Color.get(red, green, red,blue);
	@:dox(hide) public var rgra (get, never):Color; private function get_rgra() return Color.get(red, green, red, alpha);
	@:dox(hide) public var rggr (get, never):Color; private function get_rggr() return Color.get(red, green, green, red);
	@:dox(hide) public var rggg (get, never):Color; private function get_rggg() return Color.get(red, green, green, green);
	@:dox(hide) public var rggb (get, never):Color; private function get_rggb() return Color.get(red, green, green,blue);
	@:dox(hide) public var rgga (get, never):Color; private function get_rgga() return Color.get(red, green, green, alpha);
	@:dox(hide) public var rgbr (get, never):Color; private function get_rgbr() return Color.get(red, green, blue, red);
	@:dox(hide) public var rgbg (get, never):Color; private function get_rgbg() return Color.get(red, green, blue, green);
	@:dox(hide) public var rgbb (get, never):Color; private function get_rgbb() return Color.get(red, green, blue,blue);
	@:dox(hide) public var rgba (get, never):Color; private function get_rgba() return Color.get(red, green, blue, alpha);
	@:dox(hide) public var rgar (get, never):Color; private function get_rgar() return Color.get(red, green, alpha, red);
	@:dox(hide) public var rgag (get, never):Color; private function get_rgag() return Color.get(red, green, alpha, green);
	@:dox(hide) public var rgab (get, never):Color; private function get_rgab() return Color.get(red, green, alpha,blue);
	@:dox(hide) public var rgaa (get, never):Color; private function get_rgaa() return Color.get(red, green, alpha, alpha);
	@:dox(hide) public var rbrr (get, never):Color; private function get_rbrr() return Color.get(red, blue, red, red);
	@:dox(hide) public var rbrg (get, never):Color; private function get_rbrg() return Color.get(red, blue, red, green);
	@:dox(hide) public var rbrb (get, never):Color; private function get_rbrb() return Color.get(red, blue, red,blue);
	@:dox(hide) public var rbra (get, never):Color; private function get_rbra() return Color.get(red, blue, red, alpha);
	@:dox(hide) public var rbgr (get, never):Color; private function get_rbgr() return Color.get(red, blue, green, red);
	@:dox(hide) public var rbgg (get, never):Color; private function get_rbgg() return Color.get(red, blue, green, green);
	@:dox(hide) public var rbgb (get, never):Color; private function get_rbgb() return Color.get(red, blue, green,blue);
	@:dox(hide) public var rbga (get, never):Color; private function get_rbga() return Color.get(red, blue, green, alpha);
	@:dox(hide) public var rbbr (get, never):Color; private function get_rbbr() return Color.get(red, blue, blue, red);
	@:dox(hide) public var rbbg (get, never):Color; private function get_rbbg() return Color.get(red, blue, blue, green);
	@:dox(hide) public var rbbb (get, never):Color; private function get_rbbb() return Color.get(red, blue, blue,blue);
	@:dox(hide) public var rbba (get, never):Color; private function get_rbba() return Color.get(red, blue, blue, alpha);
	@:dox(hide) public var rbar (get, never):Color; private function get_rbar() return Color.get(red, blue, alpha, red);
	@:dox(hide) public var rbag (get, never):Color; private function get_rbag() return Color.get(red, blue, alpha, green);
	@:dox(hide) public var rbab (get, never):Color; private function get_rbab() return Color.get(red, blue, alpha,blue);
	@:dox(hide) public var rbaa (get, never):Color; private function get_rbaa() return Color.get(red, blue, alpha, alpha);
	@:dox(hide) public var rarr (get, never):Color; private function get_rarr() return Color.get(red, alpha, red, red);
	@:dox(hide) public var rarg (get, never):Color; private function get_rarg() return Color.get(red, alpha, red, green);
	@:dox(hide) public var rarb (get, never):Color; private function get_rarb() return Color.get(red, alpha, red,blue);
	@:dox(hide) public var rara (get, never):Color; private function get_rara() return Color.get(red, alpha, red, alpha);
	@:dox(hide) public var ragr (get, never):Color; private function get_ragr() return Color.get(red, alpha, green, red);
	@:dox(hide) public var ragg (get, never):Color; private function get_ragg() return Color.get(red, alpha, green, green);
	@:dox(hide) public var ragb (get, never):Color; private function get_ragb() return Color.get(red, alpha, green,blue);
	@:dox(hide) public var raga (get, never):Color; private function get_raga() return Color.get(red, alpha, green, alpha);
	@:dox(hide) public var rabr (get, never):Color; private function get_rabr() return Color.get(red, alpha, blue, red);
	@:dox(hide) public var rabg (get, never):Color; private function get_rabg() return Color.get(red, alpha, blue, green);
	@:dox(hide) public var rabb (get, never):Color; private function get_rabb() return Color.get(red, alpha, blue,blue);
	@:dox(hide) public var raba (get, never):Color; private function get_raba() return Color.get(red, alpha, blue, alpha);
	@:dox(hide) public var raar (get, never):Color; private function get_raar() return Color.get(red, alpha, alpha, red);
	@:dox(hide) public var raag (get, never):Color; private function get_raag() return Color.get(red, alpha, alpha, green);
	@:dox(hide) public var raab (get, never):Color; private function get_raab() return Color.get(red, alpha, alpha,blue);
	@:dox(hide) public var raaa (get, never):Color; private function get_raaa() return Color.get(red, alpha, alpha, alpha);
	@:dox(hide) public var grrr (get, never):Color; private function get_grrr() return Color.get(green, red, red, red);
	@:dox(hide) public var grrg (get, never):Color; private function get_grrg() return Color.get(green, red, red, green);
	@:dox(hide) public var grrb (get, never):Color; private function get_grrb() return Color.get(green, red, red,blue);
	@:dox(hide) public var grra (get, never):Color; private function get_grra() return Color.get(green, red, red, alpha);
	@:dox(hide) public var grgr (get, never):Color; private function get_grgr() return Color.get(green, red, green, red);
	@:dox(hide) public var grgg (get, never):Color; private function get_grgg() return Color.get(green, red, green, green);
	@:dox(hide) public var grgb (get, never):Color; private function get_grgb() return Color.get(green, red, green,blue);
	@:dox(hide) public var grga (get, never):Color; private function get_grga() return Color.get(green, red, green, alpha);
	@:dox(hide) public var grbr (get, never):Color; private function get_grbr() return Color.get(green, red, blue, red);
	@:dox(hide) public var grbg (get, never):Color; private function get_grbg() return Color.get(green, red, blue, green);
	@:dox(hide) public var grbb (get, never):Color; private function get_grbb() return Color.get(green, red, blue,blue);
	@:dox(hide) public var grba (get, never):Color; private function get_grba() return Color.get(green, red, blue, alpha);
	@:dox(hide) public var grar (get, never):Color; private function get_grar() return Color.get(green, red, alpha, red);
	@:dox(hide) public var grag (get, never):Color; private function get_grag() return Color.get(green, red, alpha, green);
	@:dox(hide) public var grab (get, never):Color; private function get_grab() return Color.get(green, red, alpha,blue);
	@:dox(hide) public var graa (get, never):Color; private function get_graa() return Color.get(green, red, alpha, alpha);
	@:dox(hide) public var ggrr (get, never):Color; private function get_ggrr() return Color.get(green, green, red, red);
	@:dox(hide) public var ggrg (get, never):Color; private function get_ggrg() return Color.get(green, green, red, green);
	@:dox(hide) public var ggrb (get, never):Color; private function get_ggrb() return Color.get(green, green, red,blue);
	@:dox(hide) public var ggra (get, never):Color; private function get_ggra() return Color.get(green, green, red, alpha);
	@:dox(hide) public var gggr (get, never):Color; private function get_gggr() return Color.get(green, green, green, red);
	@:dox(hide) public var gggg (get, never):Color; private function get_gggg() return Color.get(green, green, green, green);
	@:dox(hide) public var gggb (get, never):Color; private function get_gggb() return Color.get(green, green, green,blue);
	@:dox(hide) public var ggga (get, never):Color; private function get_ggga() return Color.get(green, green, green, alpha);
	@:dox(hide) public var ggbr (get, never):Color; private function get_ggbr() return Color.get(green, green, blue, red);
	@:dox(hide) public var ggbg (get, never):Color; private function get_ggbg() return Color.get(green, green, blue, green);
	@:dox(hide) public var ggbb (get, never):Color; private function get_ggbb() return Color.get(green, green, blue,blue);
	@:dox(hide) public var ggba (get, never):Color; private function get_ggba() return Color.get(green, green, blue, alpha);
	@:dox(hide) public var ggar (get, never):Color; private function get_ggar() return Color.get(green, green, alpha, red);
	@:dox(hide) public var ggag (get, never):Color; private function get_ggag() return Color.get(green, green, alpha, green);
	@:dox(hide) public var ggab (get, never):Color; private function get_ggab() return Color.get(green, green, alpha,blue);
	@:dox(hide) public var ggaa (get, never):Color; private function get_ggaa() return Color.get(green, green, alpha, alpha);
	@:dox(hide) public var gbrr (get, never):Color; private function get_gbrr() return Color.get(green, blue, red, red);
	@:dox(hide) public var gbrg (get, never):Color; private function get_gbrg() return Color.get(green, blue, red, green);
	@:dox(hide) public var gbrb (get, never):Color; private function get_gbrb() return Color.get(green, blue, red,blue);
	@:dox(hide) public var gbra (get, never):Color; private function get_gbra() return Color.get(green, blue, red, alpha);
	@:dox(hide) public var gbgr (get, never):Color; private function get_gbgr() return Color.get(green, blue, green, red);
	@:dox(hide) public var gbgg (get, never):Color; private function get_gbgg() return Color.get(green, blue, green, green);
	@:dox(hide) public var gbgb (get, never):Color; private function get_gbgb() return Color.get(green, blue, green,blue);
	@:dox(hide) public var gbga (get, never):Color; private function get_gbga() return Color.get(green, blue, green, alpha);
	@:dox(hide) public var gbbr (get, never):Color; private function get_gbbr() return Color.get(green, blue, blue, red);
	@:dox(hide) public var gbbg (get, never):Color; private function get_gbbg() return Color.get(green, blue, blue, green);
	@:dox(hide) public var gbbb (get, never):Color; private function get_gbbb() return Color.get(green, blue, blue,blue);
	@:dox(hide) public var gbba (get, never):Color; private function get_gbba() return Color.get(green, blue, blue, alpha);
	@:dox(hide) public var gbar (get, never):Color; private function get_gbar() return Color.get(green, blue, alpha, red);
	@:dox(hide) public var gbag (get, never):Color; private function get_gbag() return Color.get(green, blue, alpha, green);
	@:dox(hide) public var gbab (get, never):Color; private function get_gbab() return Color.get(green, blue, alpha,blue);
	@:dox(hide) public var gbaa (get, never):Color; private function get_gbaa() return Color.get(green, blue, alpha, alpha);
	@:dox(hide) public var garr (get, never):Color; private function get_garr() return Color.get(green, alpha, red, red);
	@:dox(hide) public var garg (get, never):Color; private function get_garg() return Color.get(green, alpha, red, green);
	@:dox(hide) public var garb (get, never):Color; private function get_garb() return Color.get(green, alpha, red,blue);
	@:dox(hide) public var gara (get, never):Color; private function get_gara() return Color.get(green, alpha, red, alpha);
	@:dox(hide) public var gagr (get, never):Color; private function get_gagr() return Color.get(green, alpha, green, red);
	@:dox(hide) public var gagg (get, never):Color; private function get_gagg() return Color.get(green, alpha, green, green);
	@:dox(hide) public var gagb (get, never):Color; private function get_gagb() return Color.get(green, alpha, green,blue);
	@:dox(hide) public var gaga (get, never):Color; private function get_gaga() return Color.get(green, alpha, green, alpha);
	@:dox(hide) public var gabr (get, never):Color; private function get_gabr() return Color.get(green, alpha, blue, red);
	@:dox(hide) public var gabg (get, never):Color; private function get_gabg() return Color.get(green, alpha, blue, green);
	@:dox(hide) public var gabb (get, never):Color; private function get_gabb() return Color.get(green, alpha, blue,blue);
	@:dox(hide) public var gaba (get, never):Color; private function get_gaba() return Color.get(green, alpha, blue, alpha);
	@:dox(hide) public var gaar (get, never):Color; private function get_gaar() return Color.get(green, alpha, alpha, red);
	@:dox(hide) public var gaag (get, never):Color; private function get_gaag() return Color.get(green, alpha, alpha, green);
	@:dox(hide) public var gaab (get, never):Color; private function get_gaab() return Color.get(green, alpha, alpha,blue);
	@:dox(hide) public var gaaa (get, never):Color; private function get_gaaa() return Color.get(green, alpha, alpha, alpha);
	@:dox(hide) public var brrr (get, never):Color; private function get_brrr() return Color.get(blue, red, red, red);
	@:dox(hide) public var brrg (get, never):Color; private function get_brrg() return Color.get(blue, red, red, green);
	@:dox(hide) public var brrb (get, never):Color; private function get_brrb() return Color.get(blue, red, red,blue);
	@:dox(hide) public var brra (get, never):Color; private function get_brra() return Color.get(blue, red, red, alpha);
	@:dox(hide) public var brgr (get, never):Color; private function get_brgr() return Color.get(blue, red, green, red);
	@:dox(hide) public var brgg (get, never):Color; private function get_brgg() return Color.get(blue, red, green, green);
	@:dox(hide) public var brgb (get, never):Color; private function get_brgb() return Color.get(blue, red, green,blue);
	@:dox(hide) public var brga (get, never):Color; private function get_brga() return Color.get(blue, red, green, alpha);
	@:dox(hide) public var brbr (get, never):Color; private function get_brbr() return Color.get(blue, red, blue, red);
	@:dox(hide) public var brbg (get, never):Color; private function get_brbg() return Color.get(blue, red, blue, green);
	@:dox(hide) public var brbb (get, never):Color; private function get_brbb() return Color.get(blue, red, blue,blue);
	@:dox(hide) public var brba (get, never):Color; private function get_brba() return Color.get(blue, red, blue, alpha);
	@:dox(hide) public var brar (get, never):Color; private function get_brar() return Color.get(blue, red, alpha, red);
	@:dox(hide) public var brag (get, never):Color; private function get_brag() return Color.get(blue, red, alpha, green);
	@:dox(hide) public var brab (get, never):Color; private function get_brab() return Color.get(blue, red, alpha,blue);
	@:dox(hide) public var braa (get, never):Color; private function get_braa() return Color.get(blue, red, alpha, alpha);
	@:dox(hide) public var bgrr (get, never):Color; private function get_bgrr() return Color.get(blue, green, red, red);
	@:dox(hide) public var bgrg (get, never):Color; private function get_bgrg() return Color.get(blue, green, red, green);
	@:dox(hide) public var bgrb (get, never):Color; private function get_bgrb() return Color.get(blue, green, red,blue);
	@:dox(hide) public var bgra (get, never):Color; private function get_bgra() return Color.get(blue, green, red, alpha);
	@:dox(hide) public var bggr (get, never):Color; private function get_bggr() return Color.get(blue, green, green, red);
	@:dox(hide) public var bggg (get, never):Color; private function get_bggg() return Color.get(blue, green, green, green);
	@:dox(hide) public var bggb (get, never):Color; private function get_bggb() return Color.get(blue, green, green,blue);
	@:dox(hide) public var bgga (get, never):Color; private function get_bgga() return Color.get(blue, green, green, alpha);
	@:dox(hide) public var bgbr (get, never):Color; private function get_bgbr() return Color.get(blue, green, blue, red);
	@:dox(hide) public var bgbg (get, never):Color; private function get_bgbg() return Color.get(blue, green, blue, green);
	@:dox(hide) public var bgbb (get, never):Color; private function get_bgbb() return Color.get(blue, green, blue,blue);
	@:dox(hide) public var bgba (get, never):Color; private function get_bgba() return Color.get(blue, green, blue, alpha);
	@:dox(hide) public var bgar (get, never):Color; private function get_bgar() return Color.get(blue, green, alpha, red);
	@:dox(hide) public var bgag (get, never):Color; private function get_bgag() return Color.get(blue, green, alpha, green);
	@:dox(hide) public var bgab (get, never):Color; private function get_bgab() return Color.get(blue, green, alpha,blue);
	@:dox(hide) public var bgaa (get, never):Color; private function get_bgaa() return Color.get(blue, green, alpha, alpha);
	@:dox(hide) public var bbrr (get, never):Color; private function get_bbrr() return Color.get(blue, blue, red, red);
	@:dox(hide) public var bbrg (get, never):Color; private function get_bbrg() return Color.get(blue, blue, red, green);
	@:dox(hide) public var bbrb (get, never):Color; private function get_bbrb() return Color.get(blue, blue, red,blue);
	@:dox(hide) public var bbra (get, never):Color; private function get_bbra() return Color.get(blue, blue, red, alpha);
	@:dox(hide) public var bbgr (get, never):Color; private function get_bbgr() return Color.get(blue, blue, green, red);
	@:dox(hide) public var bbgg (get, never):Color; private function get_bbgg() return Color.get(blue, blue, green, green);
	@:dox(hide) public var bbgb (get, never):Color; private function get_bbgb() return Color.get(blue, blue, green,blue);
	@:dox(hide) public var bbga (get, never):Color; private function get_bbga() return Color.get(blue, blue, green, alpha);
	@:dox(hide) public var bbbr (get, never):Color; private function get_bbbr() return Color.get(blue, blue, blue, red);
	@:dox(hide) public var bbbg (get, never):Color; private function get_bbbg() return Color.get(blue, blue, blue, green);
	@:dox(hide) public var bbbb (get, never):Color; private function get_bbbb() return Color.get(blue, blue, blue,blue);
	@:dox(hide) public var bbba (get, never):Color; private function get_bbba() return Color.get(blue, blue, blue, alpha);
	@:dox(hide) public var bbar (get, never):Color; private function get_bbar() return Color.get(blue, blue, alpha, red);
	@:dox(hide) public var bbag (get, never):Color; private function get_bbag() return Color.get(blue, blue, alpha, green);
	@:dox(hide) public var bbab (get, never):Color; private function get_bbab() return Color.get(blue, blue, alpha,blue);
	@:dox(hide) public var bbaa (get, never):Color; private function get_bbaa() return Color.get(blue, blue, alpha, alpha);
	@:dox(hide) public var barr (get, never):Color; private function get_barr() return Color.get(blue, alpha, red, red);
	@:dox(hide) public var barg (get, never):Color; private function get_barg() return Color.get(blue, alpha, red, green);
	@:dox(hide) public var barb (get, never):Color; private function get_barb() return Color.get(blue, alpha, red,blue);
	@:dox(hide) public var bara (get, never):Color; private function get_bara() return Color.get(blue, alpha, red, alpha);
	@:dox(hide) public var bagr (get, never):Color; private function get_bagr() return Color.get(blue, alpha, green, red);
	@:dox(hide) public var bagg (get, never):Color; private function get_bagg() return Color.get(blue, alpha, green, green);
	@:dox(hide) public var bagb (get, never):Color; private function get_bagb() return Color.get(blue, alpha, green,blue);
	@:dox(hide) public var baga (get, never):Color; private function get_baga() return Color.get(blue, alpha, green, alpha);
	@:dox(hide) public var babr (get, never):Color; private function get_babr() return Color.get(blue, alpha, blue, red);
	@:dox(hide) public var babg (get, never):Color; private function get_babg() return Color.get(blue, alpha, blue, green);
	@:dox(hide) public var babb (get, never):Color; private function get_babb() return Color.get(blue, alpha, blue,blue);
	@:dox(hide) public var baba (get, never):Color; private function get_baba() return Color.get(blue, alpha, blue, alpha);
	@:dox(hide) public var baar (get, never):Color; private function get_baar() return Color.get(blue, alpha, alpha, red);
	@:dox(hide) public var baag (get, never):Color; private function get_baag() return Color.get(blue, alpha, alpha, green);
	@:dox(hide) public var baab (get, never):Color; private function get_baab() return Color.get(blue, alpha, alpha,blue);
	@:dox(hide) public var baaa (get, never):Color; private function get_baaa() return Color.get(blue, alpha, alpha, alpha);
	@:dox(hide) public var arrr (get, never):Color; private function get_arrr() return Color.get(alpha, red, red, red);
	@:dox(hide) public var arrg (get, never):Color; private function get_arrg() return Color.get(alpha, red, red, green);
	@:dox(hide) public var arrb (get, never):Color; private function get_arrb() return Color.get(alpha, red, red,blue);
	@:dox(hide) public var arra (get, never):Color; private function get_arra() return Color.get(alpha, red, red, alpha);
	@:dox(hide) public var argr (get, never):Color; private function get_argr() return Color.get(alpha, red, green, red);
	@:dox(hide) public var argg (get, never):Color; private function get_argg() return Color.get(alpha, red, green, green);
	@:dox(hide) public var argb (get, never):Color; private function get_argb() return Color.get(alpha, red, green,blue);
	@:dox(hide) public var arga (get, never):Color; private function get_arga() return Color.get(alpha, red, green, alpha);
	@:dox(hide) public var arbr (get, never):Color; private function get_arbr() return Color.get(alpha, red, blue, red);
	@:dox(hide) public var arbg (get, never):Color; private function get_arbg() return Color.get(alpha, red, blue, green);
	@:dox(hide) public var arbb (get, never):Color; private function get_arbb() return Color.get(alpha, red, blue,blue);
	@:dox(hide) public var arba (get, never):Color; private function get_arba() return Color.get(alpha, red, blue, alpha);
	@:dox(hide) public var arar (get, never):Color; private function get_arar() return Color.get(alpha, red, alpha, red);
	@:dox(hide) public var arag (get, never):Color; private function get_arag() return Color.get(alpha, red, alpha, green);
	@:dox(hide) public var arab (get, never):Color; private function get_arab() return Color.get(alpha, red, alpha,blue);
	@:dox(hide) public var araa (get, never):Color; private function get_araa() return Color.get(alpha, red, alpha, alpha);
	@:dox(hide) public var agrr (get, never):Color; private function get_agrr() return Color.get(alpha, green, red, red);
	@:dox(hide) public var agrg (get, never):Color; private function get_agrg() return Color.get(alpha, green, red, green);
	@:dox(hide) public var agrb (get, never):Color; private function get_agrb() return Color.get(alpha, green, red,blue);
	@:dox(hide) public var agra (get, never):Color; private function get_agra() return Color.get(alpha, green, red, alpha);
	@:dox(hide) public var aggr (get, never):Color; private function get_aggr() return Color.get(alpha, green, green, red);
	@:dox(hide) public var aggg (get, never):Color; private function get_aggg() return Color.get(alpha, green, green, green);
	@:dox(hide) public var aggb (get, never):Color; private function get_aggb() return Color.get(alpha, green, green,blue);
	@:dox(hide) public var agga (get, never):Color; private function get_agga() return Color.get(alpha, green, green, alpha);
	@:dox(hide) public var agbr (get, never):Color; private function get_agbr() return Color.get(alpha, green, blue, red);
	@:dox(hide) public var agbg (get, never):Color; private function get_agbg() return Color.get(alpha, green, blue, green);
	@:dox(hide) public var agbb (get, never):Color; private function get_agbb() return Color.get(alpha, green, blue,blue);
	@:dox(hide) public var agba (get, never):Color; private function get_agba() return Color.get(alpha, green, blue, alpha);
	@:dox(hide) public var agar (get, never):Color; private function get_agar() return Color.get(alpha, green, alpha, red);
	@:dox(hide) public var agag (get, never):Color; private function get_agag() return Color.get(alpha, green, alpha, green);
	@:dox(hide) public var agab (get, never):Color; private function get_agab() return Color.get(alpha, green, alpha,blue);
	@:dox(hide) public var agaa (get, never):Color; private function get_agaa() return Color.get(alpha, green, alpha, alpha);
	@:dox(hide) public var abrr (get, never):Color; private function get_abrr() return Color.get(alpha, blue, red, red);
	@:dox(hide) public var abrg (get, never):Color; private function get_abrg() return Color.get(alpha, blue, red, green);
	@:dox(hide) public var abrb (get, never):Color; private function get_abrb() return Color.get(alpha, blue, red,blue);
	@:dox(hide) public var abra (get, never):Color; private function get_abra() return Color.get(alpha, blue, red, alpha);
	@:dox(hide) public var abgr (get, never):Color; private function get_abgr() return Color.get(alpha, blue, green, red);
	@:dox(hide) public var abgg (get, never):Color; private function get_abgg() return Color.get(alpha, blue, green, green);
	@:dox(hide) public var abgb (get, never):Color; private function get_abgb() return Color.get(alpha, blue, green,blue);
	@:dox(hide) public var abga (get, never):Color; private function get_abga() return Color.get(alpha, blue, green, alpha);
	@:dox(hide) public var abbr (get, never):Color; private function get_abbr() return Color.get(alpha, blue, blue, red);
	@:dox(hide) public var abbg (get, never):Color; private function get_abbg() return Color.get(alpha, blue, blue, green);
	@:dox(hide) public var abbb (get, never):Color; private function get_abbb() return Color.get(alpha, blue, blue,blue);
	@:dox(hide) public var abba (get, never):Color; private function get_abba() return Color.get(alpha, blue, blue, alpha);
	@:dox(hide) public var abar (get, never):Color; private function get_abar() return Color.get(alpha, blue, alpha, red);
	@:dox(hide) public var abag (get, never):Color; private function get_abag() return Color.get(alpha, blue, alpha, green);
	@:dox(hide) public var abab (get, never):Color; private function get_abab() return Color.get(alpha, blue, alpha,blue);
	@:dox(hide) public var abaa (get, never):Color; private function get_abaa() return Color.get(alpha, blue, alpha, alpha);
	@:dox(hide) public var aarr (get, never):Color; private function get_aarr() return Color.get(alpha, alpha, red, red);
	@:dox(hide) public var aarg (get, never):Color; private function get_aarg() return Color.get(alpha, alpha, red, green);
	@:dox(hide) public var aarb (get, never):Color; private function get_aarb() return Color.get(alpha, alpha, red,blue);
	@:dox(hide) public var aara (get, never):Color; private function get_aara() return Color.get(alpha, alpha, red, alpha);
	@:dox(hide) public var aagr (get, never):Color; private function get_aagr() return Color.get(alpha, alpha, green, red);
	@:dox(hide) public var aagg (get, never):Color; private function get_aagg() return Color.get(alpha, alpha, green, green);
	@:dox(hide) public var aagb (get, never):Color; private function get_aagb() return Color.get(alpha, alpha, green,blue);
	@:dox(hide) public var aaga (get, never):Color; private function get_aaga() return Color.get(alpha, alpha, green, alpha);
	@:dox(hide) public var aabr (get, never):Color; private function get_aabr() return Color.get(alpha, alpha, blue, red);
	@:dox(hide) public var aabg (get, never):Color; private function get_aabg() return Color.get(alpha, alpha, blue, green);
	@:dox(hide) public var aabb (get, never):Color; private function get_aabb() return Color.get(alpha, alpha, blue,blue);
	@:dox(hide) public var aaba (get, never):Color; private function get_aaba() return Color.get(alpha, alpha, blue, alpha);
	@:dox(hide) public var aaar (get, never):Color; private function get_aaar() return Color.get(alpha, alpha, alpha, red);
	@:dox(hide) public var aaag (get, never):Color; private function get_aaag() return Color.get(alpha, alpha, alpha, green);
	@:dox(hide) public var aaab (get, never):Color; private function get_aaab() return Color.get(alpha, alpha, alpha,blue);
	@:dox(hide) public var aaaa (get, never):Color; private function get_aaaa() return Color.get(alpha, alpha, alpha, alpha);

}