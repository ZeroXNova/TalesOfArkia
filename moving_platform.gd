extends Node2D
@export var offset = Vector2(100, 0)
@export var duration = 4.0


func _ready():
	start_tween()
	
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2d, "position", offset, duration / 2).from_current() 
	tween.tween_property($AnimatableBody2d, "position", Vector2.ZERO, duration / 2)

