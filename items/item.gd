extends Area2D
signal picked_up

func init(_position):
	position = _position
	$AnimationPlayer.play()

func _on_item_body_entered(body):
	return

func _on_body_entered(body):
	picked_up.emit()
	queue_free()

