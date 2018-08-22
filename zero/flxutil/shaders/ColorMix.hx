package zero.flxutil.shaders;

import flixel.system.FlxAssets;

using zero.ext.FloatExt;

class ColorMix extends FlxShader
{
    @:glFragmentSource('
        #pragma header

		uniform float uMix;
        uniform vec4 color;
		
        void main()
        {
            vec4 sample = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = mix(sample, color, uMix * sample.a);
        }'
    )

    public function new(color:Int = 0xFFFFFFFF)
    {
        super();
        this.color.value = color.to_vec4();
    }
}