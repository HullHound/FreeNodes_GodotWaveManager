extends Node

## The (optional) parent to instantiate the entity in.
@export var instantiation_container: Node

## Emitted when an object is instantiated
signal object_instantiated(object)

## Emitted when all objects have been instantiated
signal objects_instantiated(objects: Array)

## Instantiate an object from a packed scene
func instantiate_object(scene: PackedScene):
	var object = _instantiate_object(scene)
	objects_instantiated.emit([object])
	return object

## Instantiate objects from packed scenes
func instantiate_objects(scenes: Array[PackedScene]):
	var objects = Array()

	for scene in scenes:
		objects.push_back(_instantiate_object(scene))

	objects_instantiated.emit(objects)
	return objects

## Instantiate an object from a path
func instantiate_object_by_path(path):
	return instantiate_object(load(path))

## Instantiate objects from a list of paths
func instantiate_objects_by_path(paths: Array[String]):
	var objects = Array()
	for path in paths:
		objects.push_back(load(path))
	return instantiate_objects(objects)

func _instantiate_object(scene: PackedScene):
	var object = scene.instantiate()

	if instantiation_container != null:
		instantiation_container.add_child(object)
		
	object_instantiated.emit(object)

	return object
	

