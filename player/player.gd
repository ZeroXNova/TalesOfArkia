extends CharacterBody2D
@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300
enum{IDLE, RUN, JUMP, HURT, DEAD}
var state = IDLE
signal life_changed
signal died
var life = 3: set = set_life
@export var max_jumps = 2
@export var double_jump_factor = 1.4
var jump_count = 0
@export var magic_scene : PackedScene
@export var fire_rate = 0.25
var can_shoot = true
var attack_damage = 1


func _ready():
	change_state(IDLE)
	$MagicCooldown.wait_time = fire_rate
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			pass
		RUN:
			pass
		HURT:
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			await get_tree().create_timer(.5).timeout
			change_state(IDLE)
		JUMP:
			jump_count = 1
		DEAD:
			died.emit()
			hide()
			
func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	velocity.x = 0
	if Input.is_action_pressed("fire_magic") and can_shoot:
		shoot()
	if right:
		velocity.x += run_speed
		$Sprite2D.scale.x = 1
	if left:
		velocity.x -= run_speed
		$Sprite2D.scale.x = -1
 
		
	if jump and state == JUMP and jump_count < max_jumps and jump_count > 0:
		velocity.y = jump_speed / double_jump_factor
		jump_count += 1
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage(0)
				velocity.y = -200
			else:
				hurt()
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0
	if state == JUMP and velocity.y > 0:
		pass
		
func reset(_position):
	position = _position
	show()
	change_state(IDLE)
	life = 3
	
func set_life(value):
	life = value
	life_changed.emit(life)
	if life <= 0:
		change_state(DEAD)
		
func hurt():
	if state != HURT:
		change_state(HURT)
		$AudioStreamPlayer2D.play()
		
func shoot():
	if state == HURT:
		return
	can_shoot = false
	$MagicSound.play()
	$MagicCooldown.start()
	var b = magic_scene.instantiate()
	get_tree().root.add_child(b)
	b.damage = attack_damage
	b.start($Sprite2D/Staff.global_transform)
	


func _on_magic_cooldown_timeout():
	can_shoot = true
