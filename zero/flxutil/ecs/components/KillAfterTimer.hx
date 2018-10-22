package zero.flxutil.ecs.components;

class KillAfterTimer extends CallbackAfterTimer
{ 
	
	public function new()
	{
		super(function() entity.kill(), 'kill_after_timer');
	}

}