package zero.utilities;

using GOAP;
using haxe.Json;
using zero.extensions.ArrayExt;

class GOAP {}

class Planner {

	static var no_plan:Task = {
		name: 'No plan!',
		prerequisites: [],
		effects: [],
		cost: 0
	};

	public static function plan(agent:IAgent) {
		if (!agent.persona.validate_persona()) return no_plan;
		if (!agent.persona.validate_state(agent.goal)) return no_plan;
		var satisfactory_tasks = agent.get_available_tasks().get_satisfactory_tasks(agent.goal);
		if (satisfactory_tasks.length > 0) return satisfactory_tasks[0];
		var out = agent.find_best_next_step();
		if (out == null) out = no_plan;
		return out;
	}

	static function find_best_next_step(agent:IAgent):Null<Task> {
		var goal = [agent.goal];
		var queue:Array<Task> = agent.get_required_task_set(goal);
		var task:Task;
		while (queue.length > 0) {
			queue.sort((t1, t2) -> return t1.cost < t2.cost ? -1 : 1);
			task = queue.shift();
			goal = agent.get_prerequisites(task.name);
			if (goal.length == 0) return task;
			for (task in agent.get_required_task_set(goal)) queue.push(task);
		}
		return null;
	}

	static function get_available_tasks(agent:IAgent):Array<Task> {
		if (!Personas.map.exists(agent.persona)) return [];
		var available_tasks = [];
		for (task in Personas.map[agent.persona]) {
			var add = true;
			for (prerequisite in task.prerequisites) add ? add = agent.state[prerequisite] : break;
			if (add) available_tasks.push(task);
		}
		return available_tasks;
	}

	static function get_satisfactory_tasks(tasks:Array<Task>, goal:State):Array<Task> {
		var out = [for (task in tasks) if (task.effects.contains(goal)) task];
		out.sort((t1, t2) -> return t1.cost < t2.cost ? -1 : 1);
		return out;
	}

	static function get_required_task_set(agent:IAgent, requirements:Array<State>):Array<Task> {
		if (!Personas.map.exists(agent.persona)) return [];
		return [for (task in Personas.map[agent.persona]) for (requirement in requirements) if (task.effects.contains(requirement)) task];
	}

	static function get_prerequisites(agent:IAgent, task:TaskName):Array<State> {
		return [for (p in agent.persona.get_persona_task(task).prerequisites) if (!agent.state.exists(p) || !agent.state[p]) p];
	}

	static function get_persona_task(persona:Persona, task:TaskName):Null<Task> {
		for (t in Personas.map[persona]) if (t.name == task) return t;
		return null;
	}

}

interface IAgent {
	public var goal:State;
	public var persona:Persona;
	public var state:Map<State, Bool>;
}

typedef Task = {
	name:TaskName,
	prerequisites:Array<State>,
	effects:Array<State>,
	cost:Int,
}

class Personas {
	public static var map:Map<Persona, Array<Task>> = [];

	public static function add_persona(persona:Persona, tasks:Array<Task>) map.set(persona, tasks);

	public static function add_personas_from_json(json:String) {
		var personas:Array<PersonaSchema> = json.parse();
		for (persona in personas) add_persona(cast persona.name, persona.tasks);
	}

	public static function validate_persona(persona:Persona):Bool {
		return map.exists(persona);
	}

	public static function validate_task(persona:Persona, task:TaskName):Bool {
		for (t in map[persona]) if (t.name == task) return true;
		return false;
	}

	public static function validate_state(persona:Persona, state:State):Bool {
		for (task in map[persona]) {
			for (p in task.prerequisites) if (p == state) return true;
			for (e in task.effects) if (e == state) return true;
		}
		return false;
	}

	public static function get_personas():Array<Persona> return [for (p => t in map) p];

	public static function get_tasks(persona:Persona):Array<TaskName> {
		return [for (task in map[persona]) task.name];
	}

	public static function get_states(persona:Persona):Array<State> {
		var out = [];
		for (task in map[persona]) {
			for (p in task.prerequisites) if (!out.contains(p)) out.push(p);
			for (e in task.effects) if (!out.contains(e)) out.push(e);
		}
		return out;
	}
}

typedef TaskName = String;
typedef Persona = String;
typedef State = String;

typedef PersonaSchema = {
	name:String,
	tasks:Array<Task>,
}