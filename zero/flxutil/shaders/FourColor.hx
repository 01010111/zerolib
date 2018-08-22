package zero.flxutil.shaders;

import flixel.system.FlxAssets;
import zero.flxutil.util.GameLog;

using zero.ext.FloatExt;

class FourColor extends FlxShader
{
    @:glFragmentSource('
        #pragma header

		uniform float uMix;
        uniform vec4 col_0;
        uniform vec4 col_1;
        uniform vec4 col_2;
        uniform vec4 col_3;
		
        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
			
			if ((color.r + color.g + color.b) / 3.0 < 0.25) color = col_0;
			else if ((color.r + color.g + color.b) / 3.0 < 0.5) color = col_1;
			else if ((color.r + color.g + color.b) / 3.0 < 0.75) color = col_2;
			else color = col_3;

            gl_FragColor = color;
        }'
    )

    public function new(palette:Array<Int>)
    {
        super();
        set_palette(palette);
    }

	public function set_palette(palette:Array<Int>)
	{
		if (palette.length != 4)
		{
			GameLog.LOG('requires 4 Ints', ERROR);
			return;
		}
		set_color(BLACK, palette[0]);
		set_color(DARK_GREY, palette[1]);
		set_color(LIGHT_GREY, palette[2]);
		set_color(WHITE, palette[3]);
	}

	public function set_color(index:PaletteIndex, color:Int)
	{
		switch (index) {
			case BLACK:			col_0.value = color.to_vec4();
			case DARK_GREY:		col_1.value = color.to_vec4();
			case LIGHT_GREY:	col_2.value = color.to_vec4();
			case WHITE:			col_3.value = color.to_vec4();
		}
	}

}

enum PaletteIndex
{
	BLACK;
	DARK_GREY;
	LIGHT_GREY;
	WHITE;
}