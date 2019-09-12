package zero.utilities;

class ECS
{

	static var ENTITIES:Map<String, Int> = new Map();
	static var COMPONENTS:Map<String, Map<Int, Dynamic>> = new Map();
	static var SYSTEMS:Map<ISystem, Array<String>> = new Map();
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

	public static function register_system(system:ISystem, components:Array<String>)
	{
		SYSTEMS.set(system, components);
	}

	public static function delist_system(system:ISystem)
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
		for (system => components in SYSTEMS) system.update(dt, get_matching_entities(components));
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

interface ISystem
{
	public function update(dt:Float, entities:Array<String>):Void;
}