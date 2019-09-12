package zero.utilities;

using Math;
using StringTools;

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

	public static var PICO_8_BLACK:Color = [0, 0, 0, 1];
	public static var PICO_8_DARK_BLUE:Color = [29/255, 43/255, 83/255, 1];
	public static var PICO_8_DARK_PURPLE:Color = [126/255, 37/255, 83/255, 1];
	public static var PICO_8_DARK_GREEN:Color = [0, 135/255, 81/255, 1];
	public static var PICO_8_BROWN:Color = [171/255, 82/255, 54/255, 1];
	public static var PICO_8_DARK_GREY:Color = [95/255, 87/255, 79/255, 1];
	public static var PICO_8_LIGHT_GREY:Color = [194/255, 195/255, 199/255, 1];
	public static var PICO_8_WHITE:Color = [1, 241/255, 232/255, 1];
	public static var PICO_8_RED:Color = [1, 0, 77/255, 1];
	public static var PICO_8_ORANGE:Color = [1, 163/255, 0, 1];
	public static var PICO_8_YELLOW:Color = [1, 236/255, 39/255, 1];
	public static var PICO_8_GREEN:Color = [0, 228/255, 54/255, 1];
	public static var PICO_8_BLUE:Color = [41/255, 173/255, 1, 1];
	public static var PICO_8_INDIGO:Color = [131/255, 118/255, 156/255, 1];
	public static var PICO_8_PINK:Color = [1, 119/255, 168/255, 1];
	public static var PICO_8_PEACH:Color = [1, 204/255, 170/255, 1];
	
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

	public inline function rgba_to_hex():Int return ((alpha * 255).round() & 0xFF) << 24 | ((red * 255).round() & 0xFF) << 16 | ((green * 255).round() & 0xFF) << 8 | ((blue * 255).round() & 0xFF);
	public inline function from_int32(color:Int) return set((color >> 16) & 0xff, (color >> 8) & 0xff, color & 0xff, (color >> 24) & 0xff);
	public function toString():String return 'r: $red | g: $green | b: $blue | a: $alpha | #${rgba_to_hex().hex()}';
	
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

	public var rrrr (get, never):Color; public function get_rrrr() return Color.get(red, red, red, red);
	public var rrrg (get, never):Color; public function get_rrrg() return Color.get(red, red, red, green);
	public var rrrb (get, never):Color; public function get_rrrb() return Color.get(red, red, red,blue);
	public var rrra (get, never):Color; public function get_rrra() return Color.get(red, red, red, alpha);
	public var rrgr (get, never):Color; public function get_rrgr() return Color.get(red, red, green, red);
	public var rrgg (get, never):Color; public function get_rrgg() return Color.get(red, red, green, green);
	public var rrgb (get, never):Color; public function get_rrgb() return Color.get(red, red, green,blue);
	public var rrga (get, never):Color; public function get_rrga() return Color.get(red, red, green, alpha);
	public var rrbr (get, never):Color; public function get_rrbr() return Color.get(red, red, blue, red);
	public var rrbg (get, never):Color; public function get_rrbg() return Color.get(red, red, blue, green);
	public var rrbb (get, never):Color; public function get_rrbb() return Color.get(red, red, blue,blue);
	public var rrba (get, never):Color; public function get_rrba() return Color.get(red, red, blue, alpha);
	public var rrar (get, never):Color; public function get_rrar() return Color.get(red, red, alpha, red);
	public var rrag (get, never):Color; public function get_rrag() return Color.get(red, red, alpha, green);
	public var rrab (get, never):Color; public function get_rrab() return Color.get(red, red, alpha,blue);
	public var rraa (get, never):Color; public function get_rraa() return Color.get(red, red, alpha, alpha);
	public var rgrr (get, never):Color; public function get_rgrr() return Color.get(red, green, red, red);
	public var rgrg (get, never):Color; public function get_rgrg() return Color.get(red, green, red, green);
	public var rgrb (get, never):Color; public function get_rgrb() return Color.get(red, green, red,blue);
	public var rgra (get, never):Color; public function get_rgra() return Color.get(red, green, red, alpha);
	public var rggr (get, never):Color; public function get_rggr() return Color.get(red, green, green, red);
	public var rggg (get, never):Color; public function get_rggg() return Color.get(red, green, green, green);
	public var rggb (get, never):Color; public function get_rggb() return Color.get(red, green, green,blue);
	public var rgga (get, never):Color; public function get_rgga() return Color.get(red, green, green, alpha);
	public var rgbr (get, never):Color; public function get_rgbr() return Color.get(red, green, blue, red);
	public var rgbg (get, never):Color; public function get_rgbg() return Color.get(red, green, blue, green);
	public var rgbb (get, never):Color; public function get_rgbb() return Color.get(red, green, blue,blue);
	public var rgba (get, never):Color; public function get_rgba() return Color.get(red, green, blue, alpha);
	public var rgar (get, never):Color; public function get_rgar() return Color.get(red, green, alpha, red);
	public var rgag (get, never):Color; public function get_rgag() return Color.get(red, green, alpha, green);
	public var rgab (get, never):Color; public function get_rgab() return Color.get(red, green, alpha,blue);
	public var rgaa (get, never):Color; public function get_rgaa() return Color.get(red, green, alpha, alpha);
	public var rbrr (get, never):Color; public function get_rbrr() return Color.get(red, blue, red, red);
	public var rbrg (get, never):Color; public function get_rbrg() return Color.get(red, blue, red, green);
	public var rbrb (get, never):Color; public function get_rbrb() return Color.get(red, blue, red,blue);
	public var rbra (get, never):Color; public function get_rbra() return Color.get(red, blue, red, alpha);
	public var rbgr (get, never):Color; public function get_rbgr() return Color.get(red, blue, green, red);
	public var rbgg (get, never):Color; public function get_rbgg() return Color.get(red, blue, green, green);
	public var rbgb (get, never):Color; public function get_rbgb() return Color.get(red, blue, green,blue);
	public var rbga (get, never):Color; public function get_rbga() return Color.get(red, blue, green, alpha);
	public var rbbr (get, never):Color; public function get_rbbr() return Color.get(red, blue, blue, red);
	public var rbbg (get, never):Color; public function get_rbbg() return Color.get(red, blue, blue, green);
	public var rbbb (get, never):Color; public function get_rbbb() return Color.get(red, blue, blue,blue);
	public var rbba (get, never):Color; public function get_rbba() return Color.get(red, blue, blue, alpha);
	public var rbar (get, never):Color; public function get_rbar() return Color.get(red, blue, alpha, red);
	public var rbag (get, never):Color; public function get_rbag() return Color.get(red, blue, alpha, green);
	public var rbab (get, never):Color; public function get_rbab() return Color.get(red, blue, alpha,blue);
	public var rbaa (get, never):Color; public function get_rbaa() return Color.get(red, blue, alpha, alpha);
	public var rarr (get, never):Color; public function get_rarr() return Color.get(red, alpha, red, red);
	public var rarg (get, never):Color; public function get_rarg() return Color.get(red, alpha, red, green);
	public var rarb (get, never):Color; public function get_rarb() return Color.get(red, alpha, red,blue);
	public var rara (get, never):Color; public function get_rara() return Color.get(red, alpha, red, alpha);
	public var ragr (get, never):Color; public function get_ragr() return Color.get(red, alpha, green, red);
	public var ragg (get, never):Color; public function get_ragg() return Color.get(red, alpha, green, green);
	public var ragb (get, never):Color; public function get_ragb() return Color.get(red, alpha, green,blue);
	public var raga (get, never):Color; public function get_raga() return Color.get(red, alpha, green, alpha);
	public var rabr (get, never):Color; public function get_rabr() return Color.get(red, alpha, blue, red);
	public var rabg (get, never):Color; public function get_rabg() return Color.get(red, alpha, blue, green);
	public var rabb (get, never):Color; public function get_rabb() return Color.get(red, alpha, blue,blue);
	public var raba (get, never):Color; public function get_raba() return Color.get(red, alpha, blue, alpha);
	public var raar (get, never):Color; public function get_raar() return Color.get(red, alpha, alpha, red);
	public var raag (get, never):Color; public function get_raag() return Color.get(red, alpha, alpha, green);
	public var raab (get, never):Color; public function get_raab() return Color.get(red, alpha, alpha,blue);
	public var raaa (get, never):Color; public function get_raaa() return Color.get(red, alpha, alpha, alpha);
	public var grrr (get, never):Color; public function get_grrr() return Color.get(green, red, red, red);
	public var grrg (get, never):Color; public function get_grrg() return Color.get(green, red, red, green);
	public var grrb (get, never):Color; public function get_grrb() return Color.get(green, red, red,blue);
	public var grra (get, never):Color; public function get_grra() return Color.get(green, red, red, alpha);
	public var grgr (get, never):Color; public function get_grgr() return Color.get(green, red, green, red);
	public var grgg (get, never):Color; public function get_grgg() return Color.get(green, red, green, green);
	public var grgb (get, never):Color; public function get_grgb() return Color.get(green, red, green,blue);
	public var grga (get, never):Color; public function get_grga() return Color.get(green, red, green, alpha);
	public var grbr (get, never):Color; public function get_grbr() return Color.get(green, red, blue, red);
	public var grbg (get, never):Color; public function get_grbg() return Color.get(green, red, blue, green);
	public var grbb (get, never):Color; public function get_grbb() return Color.get(green, red, blue,blue);
	public var grba (get, never):Color; public function get_grba() return Color.get(green, red, blue, alpha);
	public var grar (get, never):Color; public function get_grar() return Color.get(green, red, alpha, red);
	public var grag (get, never):Color; public function get_grag() return Color.get(green, red, alpha, green);
	public var grab (get, never):Color; public function get_grab() return Color.get(green, red, alpha,blue);
	public var graa (get, never):Color; public function get_graa() return Color.get(green, red, alpha, alpha);
	public var ggrr (get, never):Color; public function get_ggrr() return Color.get(green, green, red, red);
	public var ggrg (get, never):Color; public function get_ggrg() return Color.get(green, green, red, green);
	public var ggrb (get, never):Color; public function get_ggrb() return Color.get(green, green, red,blue);
	public var ggra (get, never):Color; public function get_ggra() return Color.get(green, green, red, alpha);
	public var gggr (get, never):Color; public function get_gggr() return Color.get(green, green, green, red);
	public var gggg (get, never):Color; public function get_gggg() return Color.get(green, green, green, green);
	public var gggb (get, never):Color; public function get_gggb() return Color.get(green, green, green,blue);
	public var ggga (get, never):Color; public function get_ggga() return Color.get(green, green, green, alpha);
	public var ggbr (get, never):Color; public function get_ggbr() return Color.get(green, green, blue, red);
	public var ggbg (get, never):Color; public function get_ggbg() return Color.get(green, green, blue, green);
	public var ggbb (get, never):Color; public function get_ggbb() return Color.get(green, green, blue,blue);
	public var ggba (get, never):Color; public function get_ggba() return Color.get(green, green, blue, alpha);
	public var ggar (get, never):Color; public function get_ggar() return Color.get(green, green, alpha, red);
	public var ggag (get, never):Color; public function get_ggag() return Color.get(green, green, alpha, green);
	public var ggab (get, never):Color; public function get_ggab() return Color.get(green, green, alpha,blue);
	public var ggaa (get, never):Color; public function get_ggaa() return Color.get(green, green, alpha, alpha);
	public var gbrr (get, never):Color; public function get_gbrr() return Color.get(green, blue, red, red);
	public var gbrg (get, never):Color; public function get_gbrg() return Color.get(green, blue, red, green);
	public var gbrb (get, never):Color; public function get_gbrb() return Color.get(green, blue, red,blue);
	public var gbra (get, never):Color; public function get_gbra() return Color.get(green, blue, red, alpha);
	public var gbgr (get, never):Color; public function get_gbgr() return Color.get(green, blue, green, red);
	public var gbgg (get, never):Color; public function get_gbgg() return Color.get(green, blue, green, green);
	public var gbgb (get, never):Color; public function get_gbgb() return Color.get(green, blue, green,blue);
	public var gbga (get, never):Color; public function get_gbga() return Color.get(green, blue, green, alpha);
	public var gbbr (get, never):Color; public function get_gbbr() return Color.get(green, blue, blue, red);
	public var gbbg (get, never):Color; public function get_gbbg() return Color.get(green, blue, blue, green);
	public var gbbb (get, never):Color; public function get_gbbb() return Color.get(green, blue, blue,blue);
	public var gbba (get, never):Color; public function get_gbba() return Color.get(green, blue, blue, alpha);
	public var gbar (get, never):Color; public function get_gbar() return Color.get(green, blue, alpha, red);
	public var gbag (get, never):Color; public function get_gbag() return Color.get(green, blue, alpha, green);
	public var gbab (get, never):Color; public function get_gbab() return Color.get(green, blue, alpha,blue);
	public var gbaa (get, never):Color; public function get_gbaa() return Color.get(green, blue, alpha, alpha);
	public var garr (get, never):Color; public function get_garr() return Color.get(green, alpha, red, red);
	public var garg (get, never):Color; public function get_garg() return Color.get(green, alpha, red, green);
	public var garb (get, never):Color; public function get_garb() return Color.get(green, alpha, red,blue);
	public var gara (get, never):Color; public function get_gara() return Color.get(green, alpha, red, alpha);
	public var gagr (get, never):Color; public function get_gagr() return Color.get(green, alpha, green, red);
	public var gagg (get, never):Color; public function get_gagg() return Color.get(green, alpha, green, green);
	public var gagb (get, never):Color; public function get_gagb() return Color.get(green, alpha, green,blue);
	public var gaga (get, never):Color; public function get_gaga() return Color.get(green, alpha, green, alpha);
	public var gabr (get, never):Color; public function get_gabr() return Color.get(green, alpha, blue, red);
	public var gabg (get, never):Color; public function get_gabg() return Color.get(green, alpha, blue, green);
	public var gabb (get, never):Color; public function get_gabb() return Color.get(green, alpha, blue,blue);
	public var gaba (get, never):Color; public function get_gaba() return Color.get(green, alpha, blue, alpha);
	public var gaar (get, never):Color; public function get_gaar() return Color.get(green, alpha, alpha, red);
	public var gaag (get, never):Color; public function get_gaag() return Color.get(green, alpha, alpha, green);
	public var gaab (get, never):Color; public function get_gaab() return Color.get(green, alpha, alpha,blue);
	public var gaaa (get, never):Color; public function get_gaaa() return Color.get(green, alpha, alpha, alpha);
	public var brrr (get, never):Color; public function get_brrr() return Color.get(blue, red, red, red);
	public var brrg (get, never):Color; public function get_brrg() return Color.get(blue, red, red, green);
	public var brrb (get, never):Color; public function get_brrb() return Color.get(blue, red, red,blue);
	public var brra (get, never):Color; public function get_brra() return Color.get(blue, red, red, alpha);
	public var brgr (get, never):Color; public function get_brgr() return Color.get(blue, red, green, red);
	public var brgg (get, never):Color; public function get_brgg() return Color.get(blue, red, green, green);
	public var brgb (get, never):Color; public function get_brgb() return Color.get(blue, red, green,blue);
	public var brga (get, never):Color; public function get_brga() return Color.get(blue, red, green, alpha);
	public var brbr (get, never):Color; public function get_brbr() return Color.get(blue, red, blue, red);
	public var brbg (get, never):Color; public function get_brbg() return Color.get(blue, red, blue, green);
	public var brbb (get, never):Color; public function get_brbb() return Color.get(blue, red, blue,blue);
	public var brba (get, never):Color; public function get_brba() return Color.get(blue, red, blue, alpha);
	public var brar (get, never):Color; public function get_brar() return Color.get(blue, red, alpha, red);
	public var brag (get, never):Color; public function get_brag() return Color.get(blue, red, alpha, green);
	public var brab (get, never):Color; public function get_brab() return Color.get(blue, red, alpha,blue);
	public var braa (get, never):Color; public function get_braa() return Color.get(blue, red, alpha, alpha);
	public var bgrr (get, never):Color; public function get_bgrr() return Color.get(blue, green, red, red);
	public var bgrg (get, never):Color; public function get_bgrg() return Color.get(blue, green, red, green);
	public var bgrb (get, never):Color; public function get_bgrb() return Color.get(blue, green, red,blue);
	public var bgra (get, never):Color; public function get_bgra() return Color.get(blue, green, red, alpha);
	public var bggr (get, never):Color; public function get_bggr() return Color.get(blue, green, green, red);
	public var bggg (get, never):Color; public function get_bggg() return Color.get(blue, green, green, green);
	public var bggb (get, never):Color; public function get_bggb() return Color.get(blue, green, green,blue);
	public var bgga (get, never):Color; public function get_bgga() return Color.get(blue, green, green, alpha);
	public var bgbr (get, never):Color; public function get_bgbr() return Color.get(blue, green, blue, red);
	public var bgbg (get, never):Color; public function get_bgbg() return Color.get(blue, green, blue, green);
	public var bgbb (get, never):Color; public function get_bgbb() return Color.get(blue, green, blue,blue);
	public var bgba (get, never):Color; public function get_bgba() return Color.get(blue, green, blue, alpha);
	public var bgar (get, never):Color; public function get_bgar() return Color.get(blue, green, alpha, red);
	public var bgag (get, never):Color; public function get_bgag() return Color.get(blue, green, alpha, green);
	public var bgab (get, never):Color; public function get_bgab() return Color.get(blue, green, alpha,blue);
	public var bgaa (get, never):Color; public function get_bgaa() return Color.get(blue, green, alpha, alpha);
	public var bbrr (get, never):Color; public function get_bbrr() return Color.get(blue, blue, red, red);
	public var bbrg (get, never):Color; public function get_bbrg() return Color.get(blue, blue, red, green);
	public var bbrb (get, never):Color; public function get_bbrb() return Color.get(blue, blue, red,blue);
	public var bbra (get, never):Color; public function get_bbra() return Color.get(blue, blue, red, alpha);
	public var bbgr (get, never):Color; public function get_bbgr() return Color.get(blue, blue, green, red);
	public var bbgg (get, never):Color; public function get_bbgg() return Color.get(blue, blue, green, green);
	public var bbgb (get, never):Color; public function get_bbgb() return Color.get(blue, blue, green,blue);
	public var bbga (get, never):Color; public function get_bbga() return Color.get(blue, blue, green, alpha);
	public var bbbr (get, never):Color; public function get_bbbr() return Color.get(blue, blue, blue, red);
	public var bbbg (get, never):Color; public function get_bbbg() return Color.get(blue, blue, blue, green);
	public var bbbb (get, never):Color; public function get_bbbb() return Color.get(blue, blue, blue,blue);
	public var bbba (get, never):Color; public function get_bbba() return Color.get(blue, blue, blue, alpha);
	public var bbar (get, never):Color; public function get_bbar() return Color.get(blue, blue, alpha, red);
	public var bbag (get, never):Color; public function get_bbag() return Color.get(blue, blue, alpha, green);
	public var bbab (get, never):Color; public function get_bbab() return Color.get(blue, blue, alpha,blue);
	public var bbaa (get, never):Color; public function get_bbaa() return Color.get(blue, blue, alpha, alpha);
	public var barr (get, never):Color; public function get_barr() return Color.get(blue, alpha, red, red);
	public var barg (get, never):Color; public function get_barg() return Color.get(blue, alpha, red, green);
	public var barb (get, never):Color; public function get_barb() return Color.get(blue, alpha, red,blue);
	public var bara (get, never):Color; public function get_bara() return Color.get(blue, alpha, red, alpha);
	public var bagr (get, never):Color; public function get_bagr() return Color.get(blue, alpha, green, red);
	public var bagg (get, never):Color; public function get_bagg() return Color.get(blue, alpha, green, green);
	public var bagb (get, never):Color; public function get_bagb() return Color.get(blue, alpha, green,blue);
	public var baga (get, never):Color; public function get_baga() return Color.get(blue, alpha, green, alpha);
	public var babr (get, never):Color; public function get_babr() return Color.get(blue, alpha, blue, red);
	public var babg (get, never):Color; public function get_babg() return Color.get(blue, alpha, blue, green);
	public var babb (get, never):Color; public function get_babb() return Color.get(blue, alpha, blue,blue);
	public var baba (get, never):Color; public function get_baba() return Color.get(blue, alpha, blue, alpha);
	public var baar (get, never):Color; public function get_baar() return Color.get(blue, alpha, alpha, red);
	public var baag (get, never):Color; public function get_baag() return Color.get(blue, alpha, alpha, green);
	public var baab (get, never):Color; public function get_baab() return Color.get(blue, alpha, alpha,blue);
	public var baaa (get, never):Color; public function get_baaa() return Color.get(blue, alpha, alpha, alpha);
	public var arrr (get, never):Color; public function get_arrr() return Color.get(alpha, red, red, red);
	public var arrg (get, never):Color; public function get_arrg() return Color.get(alpha, red, red, green);
	public var arrb (get, never):Color; public function get_arrb() return Color.get(alpha, red, red,blue);
	public var arra (get, never):Color; public function get_arra() return Color.get(alpha, red, red, alpha);
	public var argr (get, never):Color; public function get_argr() return Color.get(alpha, red, green, red);
	public var argg (get, never):Color; public function get_argg() return Color.get(alpha, red, green, green);
	public var argb (get, never):Color; public function get_argb() return Color.get(alpha, red, green,blue);
	public var arga (get, never):Color; public function get_arga() return Color.get(alpha, red, green, alpha);
	public var arbr (get, never):Color; public function get_arbr() return Color.get(alpha, red, blue, red);
	public var arbg (get, never):Color; public function get_arbg() return Color.get(alpha, red, blue, green);
	public var arbb (get, never):Color; public function get_arbb() return Color.get(alpha, red, blue,blue);
	public var arba (get, never):Color; public function get_arba() return Color.get(alpha, red, blue, alpha);
	public var arar (get, never):Color; public function get_arar() return Color.get(alpha, red, alpha, red);
	public var arag (get, never):Color; public function get_arag() return Color.get(alpha, red, alpha, green);
	public var arab (get, never):Color; public function get_arab() return Color.get(alpha, red, alpha,blue);
	public var araa (get, never):Color; public function get_araa() return Color.get(alpha, red, alpha, alpha);
	public var agrr (get, never):Color; public function get_agrr() return Color.get(alpha, green, red, red);
	public var agrg (get, never):Color; public function get_agrg() return Color.get(alpha, green, red, green);
	public var agrb (get, never):Color; public function get_agrb() return Color.get(alpha, green, red,blue);
	public var agra (get, never):Color; public function get_agra() return Color.get(alpha, green, red, alpha);
	public var aggr (get, never):Color; public function get_aggr() return Color.get(alpha, green, green, red);
	public var aggg (get, never):Color; public function get_aggg() return Color.get(alpha, green, green, green);
	public var aggb (get, never):Color; public function get_aggb() return Color.get(alpha, green, green,blue);
	public var agga (get, never):Color; public function get_agga() return Color.get(alpha, green, green, alpha);
	public var agbr (get, never):Color; public function get_agbr() return Color.get(alpha, green, blue, red);
	public var agbg (get, never):Color; public function get_agbg() return Color.get(alpha, green, blue, green);
	public var agbb (get, never):Color; public function get_agbb() return Color.get(alpha, green, blue,blue);
	public var agba (get, never):Color; public function get_agba() return Color.get(alpha, green, blue, alpha);
	public var agar (get, never):Color; public function get_agar() return Color.get(alpha, green, alpha, red);
	public var agag (get, never):Color; public function get_agag() return Color.get(alpha, green, alpha, green);
	public var agab (get, never):Color; public function get_agab() return Color.get(alpha, green, alpha,blue);
	public var agaa (get, never):Color; public function get_agaa() return Color.get(alpha, green, alpha, alpha);
	public var abrr (get, never):Color; public function get_abrr() return Color.get(alpha, blue, red, red);
	public var abrg (get, never):Color; public function get_abrg() return Color.get(alpha, blue, red, green);
	public var abrb (get, never):Color; public function get_abrb() return Color.get(alpha, blue, red,blue);
	public var abra (get, never):Color; public function get_abra() return Color.get(alpha, blue, red, alpha);
	public var abgr (get, never):Color; public function get_abgr() return Color.get(alpha, blue, green, red);
	public var abgg (get, never):Color; public function get_abgg() return Color.get(alpha, blue, green, green);
	public var abgb (get, never):Color; public function get_abgb() return Color.get(alpha, blue, green,blue);
	public var abga (get, never):Color; public function get_abga() return Color.get(alpha, blue, green, alpha);
	public var abbr (get, never):Color; public function get_abbr() return Color.get(alpha, blue, blue, red);
	public var abbg (get, never):Color; public function get_abbg() return Color.get(alpha, blue, blue, green);
	public var abbb (get, never):Color; public function get_abbb() return Color.get(alpha, blue, blue,blue);
	public var abba (get, never):Color; public function get_abba() return Color.get(alpha, blue, blue, alpha);
	public var abar (get, never):Color; public function get_abar() return Color.get(alpha, blue, alpha, red);
	public var abag (get, never):Color; public function get_abag() return Color.get(alpha, blue, alpha, green);
	public var abab (get, never):Color; public function get_abab() return Color.get(alpha, blue, alpha,blue);
	public var abaa (get, never):Color; public function get_abaa() return Color.get(alpha, blue, alpha, alpha);
	public var aarr (get, never):Color; public function get_aarr() return Color.get(alpha, alpha, red, red);
	public var aarg (get, never):Color; public function get_aarg() return Color.get(alpha, alpha, red, green);
	public var aarb (get, never):Color; public function get_aarb() return Color.get(alpha, alpha, red,blue);
	public var aara (get, never):Color; public function get_aara() return Color.get(alpha, alpha, red, alpha);
	public var aagr (get, never):Color; public function get_aagr() return Color.get(alpha, alpha, green, red);
	public var aagg (get, never):Color; public function get_aagg() return Color.get(alpha, alpha, green, green);
	public var aagb (get, never):Color; public function get_aagb() return Color.get(alpha, alpha, green,blue);
	public var aaga (get, never):Color; public function get_aaga() return Color.get(alpha, alpha, green, alpha);
	public var aabr (get, never):Color; public function get_aabr() return Color.get(alpha, alpha, blue, red);
	public var aabg (get, never):Color; public function get_aabg() return Color.get(alpha, alpha, blue, green);
	public var aabb (get, never):Color; public function get_aabb() return Color.get(alpha, alpha, blue,blue);
	public var aaba (get, never):Color; public function get_aaba() return Color.get(alpha, alpha, blue, alpha);
	public var aaar (get, never):Color; public function get_aaar() return Color.get(alpha, alpha, alpha, red);
	public var aaag (get, never):Color; public function get_aaag() return Color.get(alpha, alpha, alpha, green);
	public var aaab (get, never):Color; public function get_aaab() return Color.get(alpha, alpha, alpha,blue);
	public var aaaa (get, never):Color; public function get_aaaa() return Color.get(alpha, alpha, alpha, alpha);

}