package zero.utilities;

using Math;

/**
 * A Synced getter for sin/cos
 * 
 * **Usage**
 * 
 * - Update counter: `SyncedSin.update(delta_time)`
 * - Get synced sin/cos values: `SyncedSin.synced_sin(10);` <- returns a synced sin value that takes 10 seconds to loop
 */
class SyncedSin
{

	static var counter = 0.0;
	public static function update(dt:Float) counter = (counter + dt) % 1;
	public static function synced_sin(wavelength:Float) return (counter * Math.PI * 2 / wavelength).sin();
	public static function synced_cos(wavelength:Float) return (counter * Math.PI * 2 / wavelength).cos();

}