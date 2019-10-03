package zero.utilities;

using Math;

class SinCosMap
{

	static var counter = 0.0;
	public static function update(dt:Float) counter = (counter + dt) % 1;
	public static function synced_sin(wavelength:Float) return (counter * Math.PI * 2 / wavelength).sin();
	public static function synced_cos(wavelength:Float) return (counter * Math.PI * 2 / wavelength).cos();

}