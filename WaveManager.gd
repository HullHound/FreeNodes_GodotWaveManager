extends Node

## The parent container for the newly generated entities.
@export var generation_container: Node :
	get:
		return $ObjectPlacer3D.placement_container
	set(value):
		$ObjectPlacer3D.placement_container = value

## The locations to place the newly generated entities.
## Locations will be used sequentially and repeat when all have been used.
## The all_locations_used signal will be emitted once all locations have been used. Subscribe to this signal to know when to update this property for more varied spawn locations.
@export var spawn_locations: Array[Vector3] :
	get:
		return $ObjectPlacer3D.placement_locations
	set(value):
		$ObjectPlacer3D.placement_locations = value

## The scenes to instantiate.
@export var scenes_to_spawn: Array[PackedScene]

## Should the wave timer start when the node is ready.
@export var auto_start: bool

## Seconds between the start of each wave.
## Keep this figure larger than the time it takes to spawn all entities.
@export var seconds_between_waves: float :
	get:
		return $Timer.wait_time
	set(value):
		$Timer.wait_time = value

## Seconds delay when all spawn locations have been used.
## This can be used to spawn entities in a line when the number of spawn locations is lower than the number of entities being spawned.
@export var seconds_between_mini_waves: float :
	get:
		return $ObjectPlacer3D.seconds_delay_on_locations_used
	set(value):
		$ObjectPlacer3D.seconds_delay_on_locations_used = value

## Emitted each time an entity is created
signal entity_created(entity: Node3D)

## Emitted after all entities in a wave have been created
signal wave_entities_created(entities: Array[Node3D])

## Emitted when all of the spawn locations have been used.
signal all_locations_used

## Seconds until the next wave starts
var seconds_until_next_wave: float :
	get:
		return $Timer.time_left

@onready var object_instantiator = $ObjectInstantiator
@onready var object_placer = $ObjectPlacer3D
@onready var timer = $Timer

func _ready():
	_initiate()

func _initiate():	
	if auto_start:
		start()

## Start the Wave Timer
func start():
	timer.start()

## Start one wave
func start_wave():
	_on_timer_timeout()

func _on_timer_timeout():
	object_instantiator.instantiate_objects(scenes_to_spawn)

func _on_object_instantiator_objects_instantiated(objects: Array):
	var array: Array[Node3D] = []
	
	for item in objects:
		array.push_back(item as Node3D)
	
	object_placer.place_objects(array)

func _on_object_placer_3d_object_placed(object) -> void:
	entity_created.emit(object)

func _on_object_placer_3d_placement_locations_all_used() -> void:
	all_locations_used.emit()

func _on_object_placer_3d_all_objects_placed(objects) -> void:
	wave_entities_created.emit(objects)
