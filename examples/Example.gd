extends Node3D

@onready var wave_manager = $WaveManager
@onready var wave_timer_label = $WaveTimer

var particle = preload("res://examples/particles/CreatedParticle.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (wave_timer_label != null):
		wave_timer_label.text = "Time until next wave: " + str(wave_manager.seconds_until_next_wave as int + 1)

func _on_wave_manager_entity_created(entity) -> void:
	var item = particle.instantiate()
	item.position = entity.position
	add_child(item)
	item.emitting = true

	var particle_tween = create_tween()
	particle_tween.tween_interval(2.0)
	particle_tween.tween_callback(item.queue_free)
	
	var entity_tween = create_tween()
	entity_tween.tween_interval(6.0)
	entity_tween.tween_callback(entity.queue_free)
