extends Node

## The (optional) parent to place the entity in.
@export var placement_container: Node

## The list of locations to place entities.
## This list is used sequentially and repeats when all have been used.
@export var placement_locations: Array[Vector3]

## Seconds delay between each placement of an entity
@export var seconds_between_placement: float = 0

## Seconds delay when all locations have been used
## The placement_locations_all_used signal will be emitted once all locations have been used. Subscribe to this signal to know when to update this property for more varied placement locations.
@export var seconds_delay_on_locations_used: float = 0

var _placement_locations_index: int = 0

## Emitted when all placement locations have been used.
## Subscribe to this signal to know when to update this property for more varied placement locations.
signal placement_locations_all_used

## Emitted when an object has been placed
signal object_placed(object)

##Emitted when all provided objects have been placed
signal all_objects_placed(objects: Array[Node3D])

## Place object using the provided locations
func place_object(object):
	_place_object(object)
	
	all_objects_placed.emit([object])

## Place objects using the provided locations
func place_objects(objects: Array[Node3D]):
	var index = 0
		
	for object in objects:
		if _placement_locations_index >= len(placement_locations):
			if seconds_delay_on_locations_used > 0:
				await get_tree().create_timer(seconds_delay_on_locations_used).timeout
			_placement_locations_index = 0
		
		_place_object(object)
		
		if index < len(objects):
			if seconds_between_placement > 0:
				await get_tree().create_timer(seconds_between_placement).timeout
		
		index += 1
		
	all_objects_placed.emit(objects)

func _place_object(object: Node3D):
	object.position = _get_next_location()
	if placement_container != null:
		placement_container.add_child(object)
	
	object_placed.emit(object)

func _get_next_location() -> Vector3:
	var location = placement_locations[_placement_locations_index]
	_placement_locations_index += 1	
	
	if _placement_locations_index >= len(placement_locations):
		placement_locations_all_used.emit()

	return location

