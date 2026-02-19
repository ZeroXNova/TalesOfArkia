extends MarginContainer
@onready var life_counter = $HBoxContainer/LifeCounter.get_children()
@onready var rune_counter = $HBoxContainer/RuneCounter.get_children()

func update_life(value):
	for heart in life_counter.size():
		life_counter[heart].visible = value > heart
		
		
func update_runes(value):
	for rune in rune_counter.size():
		rune_counter[rune].visible = value > rune


