extends Node2D
signal score_changed
var item_scene = load("res://items/item.tscn")
var score = 0: set = set_score
var door_scene = load("res://items/door.tscn")


func _ready():
	$Item.hide()
	$Item2.hide()
	$Item3.hide()
	score = 0
	score_changed.emit(score)
	$Player.reset($SpawnPoint.position)
	set_camera_limits()
	spawn_items()
	$ParallaxBackground2/ParallaxLayer/Night.hide()
	$Day.start(30)

func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func spawn_items():
	var item_cells = $Items.get_used_cells(0)
	for cell in item_cells:
		var data = $Items.get_cell_tile_data(0, cell)
		var type = data.get_custom_data("type")
		if type == "door":
			var door = door_scene.instantiate()
			add_child(door)
			door.position = $Items.map_to_local(cell)
			door.body_entered.connect(_on_door_entered)
	$Item.show()
	$Item2.show()
	$Item3.show()
	$Item.picked_up.connect(self._on_item_picked_up)
	$Item2.picked_up.connect(self._on_item_picked_up)
	$Item3.picked_up.connect(self._on_item_picked_up)
		
func _on_item_picked_up():
	score += 1
	$Player/PickedUp.play()
	set_score(score)
	
func set_score(value):
	score = value
	score_changed.emit(score)

func _on_door_entered(body):
	if score >= 3:
		GameState.next_level()

func _on_player_died():
	GameState.restart()


func _on_day_timeout():
	$Night.start(30)
	$ParallaxBackground2/ParallaxLayer/Night.show()


func _on_night_timeout():
	$Night.start(30)
	$ParallaxBackground2/ParallaxLayer/Night.hide()
