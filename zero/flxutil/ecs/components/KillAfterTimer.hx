package zero.flxutil.ecs.components;

class KillAfterTimer extends CallbackAfterTimer
{ 
	
	/**
	 * Kills an entity after a timer. Use reset() to start timer.
	 * @return super(function()
	 */
	public function new() super(function() { entity.kill(); }, 'kill_after_timer');

}