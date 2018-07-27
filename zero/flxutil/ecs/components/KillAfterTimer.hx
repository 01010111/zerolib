package zero.flxutil.ecs.components;

class KillAfterTimer extends CallbackAfterTimer
{ 
	
	public function new()
	{
		super(() -> entity.kill(), 'kill_after_timer');
	}

}