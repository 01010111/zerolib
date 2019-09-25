package zero.utilities;

/**
 * An extremely simple Entity-Component-System implementation!
 * 
 * **Usage:**
 * 
 * - Entities are just integers, but you register and look them up using Strings: `ECS.register_entity('player');`  
 * - Components are just sets of data tied to an entity: `ECS.register_component('player', 'position', { x: 0, y: 0 });`  
 * - Systems are classes with an `update()` function that modify data. The update function is fed delta time and an array of entities.  
 * - In your system's `update()` loop, you can use `ECS.get_data()` to get the relevant data:  
 * - for example:  
 * ```
 * 	class MoveRightSystem extends System {
 * 		override public function update(dt:Float, entities:Array<String>) for (entity in entities) {
 * 			var position = ECS.get_data(entity, 'position');
 * 			position.x++;
 * 		}
 * 	}
 * ```
 * - When you have a System set up, register it and give it a list of necessary components: `ECS.register_system(new MoveRightSystem(), ['position']);`  
 * - To update all registered systems, use the tick function: `ECS.tick(1/60);`  
 * - You can also delist entities, components, and systems.
 */
class ECS
{

	static var ENTITIES:Map<String, Int> = new Map();
	static var COMPONENTS:Map<String, Map<Int, Dynamic>> = new Map();
	static var SYSTEMS:Map<System, Array<String>> = new Map();
	static var ID_NUMERATOR:Int = 0;

	public static function register_entity(name:String)
	{
		if (ENTITIES.exists(name) || name.length == 0) return error('Entity $name already exists!');
		ENTITIES.set(name, ID_NUMERATOR++);
		return name;
	}

	public static function delist_entity(name:String)
	{
		if (!ENTITIES.exists(name)) return trace('Entity $name does not exist!');
		for (cname in COMPONENTS.keys()) delist_component(name, cname);
		ENTITIES.remove(name);
	}

	public static function register_component(entity:String, component:String, data:Dynamic)
	{
		if (entity.length == 0) return error('Invalid Entity!');
		if (!COMPONENTS.exists(component)) COMPONENTS.set(component, []);
		COMPONENTS[component].set(ENTITIES[entity], data);
		return entity;
	}

	public static function delist_component(entity:String, component:String)
	{
		if (!COMPONENTS.exists(component)) return trace('Component $component does not exist!');
		if (!ENTITIES.exists(entity)) trace('Entity $entity does not exist!');
		if (!COMPONENTS[component].exists(ENTITIES[entity])) return trace('Component $component not found in $entity!');
		COMPONENTS[component].remove(ENTITIES[entity]);
	}

	public static function register_system(system:System, components:Array<String>)
	{
		SYSTEMS.set(system, components);
	}

	public static function delist_system(system:System)
	{
		if (!SYSTEMS.exists(system)) return trace('System ${Type.getClassName(Type.getClass(system))} does not exist!');
		SYSTEMS.remove(system);
	}
	
	public static function get_entity_id(entity:String):Int
	{
		if (ENTITIES.exists(entity)) return ENTITIES[entity];
		error('Entity $entity does not exist!');
		return -1;
	}

	public static function get_entity_name(entity:Int):String
	{
		for (name => id in ENTITIES) if (id == entity) return name;
		return error('Entity with ID $entity does not exist!');
	}

	public static function get_entity_data(entity:String):Map<String, Dynamic>
	{
		if (!ENTITIES.exists(entity)) return [ for (i in 0...error('Entity $entity does not exist!').length) {} ];
		return [ for (name => data in COMPONENTS) if (data.exists(ENTITIES[entity])) name => data[ENTITIES[entity]] ];
	}

	public static function get_data(entity:String, component:String):Dynamic
	{
		if (!COMPONENTS.exists(component)) return error('Component $component does not exist!');
		if (!ENTITIES.exists(entity)) return error('Entity $entity does not exist!');
		if (!COMPONENTS[component].exists(ENTITIES[entity])) return error('No component $component found for entity $entity!');
		return COMPONENTS[component][ENTITIES[entity]];
	}

	public static function tick(dt:Float = 0)
	{
		var systems = [for (s in SYSTEMS.keys()) s];
		systems.sort((s1, s2) -> return s1.priority > s2.priority ? -1 : 1);
		for (system in systems) system.update(dt, get_matching_entities(SYSTEMS[system]));
	}

	static function get_matching_entities(components:Array<String>):Array<String>
	{
		var out = [];
		for (name => id in ENTITIES)
		{
			var add = true;
			for (component in components) if (!COMPONENTS.exists(component) || !COMPONENTS[component].exists(id)) add = false;
			if (add) out.push(name);
		}
		return out;
	}

	static function error(msg:String):String
	{
		trace('ERROR: $msg');
		return '';
	}

}

@:dox(hide)
class System
{
	public static var PRIORITY_LAST:Int = -9999999;
	public static var PRIORITY_FIRST:Int = 9999999;
	public var priority:Int;
	public function new(priority:Int = 0) this.priority = priority;
	public function update(dt:Float, entities:Array<String>){}
}