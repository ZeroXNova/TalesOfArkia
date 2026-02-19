extends Control

func _input(event):
	if event.is_action_pressed("ui_select"):
		$Start.play()
		await $Start.finished
		GameState.next_level()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()


