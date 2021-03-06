extends KinematicBody2D

var speed = 0
var max_speed = 100

var weapon = "sword"

var health = 16
const MAX_HEALTH = 16
signal damaged(damage_amount)
signal healed(heal_amount)
signal done_transitioning

var state = "Idle"

var charging = false
var charge_vec = Vector2()

var speed_dampening_multiplier = 5
var default_speed_dampening = 5

var last_dir = Vector2()

const target_width = 320
const target_height = 180
const KNOCKBACK_AMOUNT = 30

var attack_nudge = false

var moving_left = false
var mouse_left = false

var distance_travelled = 0

var invulnerable = 0
const inv_time = 0.8

var step_timer = 0.5
var regen_timer = 5.0

var active = false

var stun = 0

func _ready():
	self.connect("damaged", $UI_Layer/UI/Heart_Controller, "damage")
	self.connect("healed", $UI_Layer/UI/Heart_Controller, "heal")
	$UI_Layer/Light2D.visible = true
	rescale_camera()

func rescale_camera():
	$Camera2D.zoom.x = target_width / get_viewport().size.x
	$Camera2D.zoom.y = target_height / get_viewport().size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active and state != "Death": movement(delta)
	
	if state == "Move":
		step_timer -= delta
	if step_timer <= 0:
		play_step_sound()
	
	if health < MAX_HEALTH and state != "Death":
		regen_timer -= delta
	if regen_timer <= 0:
		heal(1)
		regen_timer = 5.0
	
	invulnerable = max(0, invulnerable - delta)
	stun = max(0, stun - delta)

func movement(delta):
	var mouse_pos = get_local_mouse_position()
	
	var dir : Vector2 = Vector2()
	
	if charging:
		dir = charge_vec
		speed = max_speed * 1.5
		speed_dampening_multiplier = 4
		
		last_dir = dir
	elif stun == 0:
		if Input.is_action_pressed("Up"):
			dir.y -= 1
		if Input.is_action_pressed("Down"):
			dir.y += 1
		if Input.is_action_pressed("Left"):
			dir.x -= 1
		if Input.is_action_pressed("Right"):
			dir.x += 1
		
		dir = dir.normalized()
		
	if dir != Vector2():
		speed_dampening_multiplier = default_speed_dampening
		
		speed = min(max_speed, speed + max_speed * speed_dampening_multiplier * delta)
		
		last_dir = dir
	else:
		speed = max(0, speed - max_speed * speed_dampening_multiplier * delta)
		
		dir = last_dir
	
	if attack_nudge:
		if speed <= max_speed * 0.4:
			dir = mouse_pos.normalized() * 0.4
		else:
			dir += mouse_pos.normalized() * 0.4
		
		speed = max(speed, max_speed * 0.3)
		
		attack_nudge = false
	
	if dir.x < 0:
		if moving_left == false: $Player_Sprite.change_state("Move", true)
		moving_left = true
	elif dir.x > 0:
		if moving_left == true: $Player_Sprite.change_state("Move", false)
		moving_left = false
	
	if speed == 0:
		if state != "Idle":
			state = "Idle"
			$Player_Sprite.change_state("Idle", moving_left)
	else:
		if state != "Move":
			state = "Move"
			$Player_Sprite.change_state("Move", moving_left)
	
	var distance = move_and_slide(dir * speed, Vector2.UP)
	
	distance_travelled += distance.length() * delta
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func play_step_sound():
	step_timer = 0.35
	var random_sound_index = randi() % 3 + 1
	get_node("Step" + str(random_sound_index)).play()

func change_weapon(new_weapon):
	weapon = new_weapon
	
	charging = false
	
	remove_weapon_hitboxes()
	$UI_Layer/UI/Weapon.change_weapon(new_weapon)
	$Weapon_Switch.play()

func get_weapon_damage():
	get_node("Hurt_Enemy" + str(randi() % 2)).play()
	match weapon:
		"sword": 
			return 30
		"shield": 
			return 20
		"claws": 
			return 16
		"spear": 
			return 35
		"shuriken": 
			return 12
		"grenade": 
			return 50
		"trail": 
			return 4
		"flamethrower": 
			return 8
		"laser": 
			return 3
		_:
			return 1
	
func remove_weapon_hitboxes():
	for c in get_children():
		if c.name.count("weapon_area") > 0: 
			c.queue_free()

func create_circle_hurtbox(offset, radius):
	var area = Area2D.new()
	var col_shape = CollisionShape2D.new()
	col_shape.shape = CircleShape2D.new()
	col_shape.shape.radius = radius
	area.name = "weapon_area"
	area.add_to_group("player_damage")
	
	area.position += offset
	
	add_child(area)
	area.add_child(col_shape)

func create_rectangle_hurtbox(start, end, width):
	var area = Area2D.new()
	var col_shape = CollisionShape2D.new()
	col_shape.shape = RectangleShape2D.new()
	
	col_shape.rotate(atan2(start.y - end.y, start.x - end.x))
	
	col_shape.shape.extents.y = width / 2
	col_shape.shape.extents.x = (end.length() - start.length()) / 2
	
	area.position.x += (end.x + start.x) / 2
	area.position.y += (end.y + start.y) / 2
	
	area.name = "weapon_area"
	area.add_to_group("player_damage")
	
	add_child(area)
	area.add_child(col_shape)

func take_damage(damage):
	if invulnerable == 0:
		invulnerable = inv_time
		
		health -= damage
		
		if health <= 0 and state != "Death":
			state = "Death"
			weapon = "none"
			$Player_Sprite.change_state("Death", moving_left)
			$CollisionShape2D.position = Vector2(10000, 10000)
			die()
		else:
			$Player_Sprite.hurt(moving_left)
		emit_signal("damaged", damage)

func apply_knockback(enemy_pos, intensity = 20):
	if invulnerable == 0:
		stun = 0.2
		last_dir = position - enemy_pos
		speed = intensity
		speed_dampening_multiplier = 3
		
func die():
	get_parent().get_node("Music").playing = false
	$Death_Sound.play()
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, $Camera2D.zoom/2, 3.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$UI_Layer/Transition.transition()
	yield($UI_Layer/Transition, "done_transition")
	
	get_tree().reload_current_scene()

#func apply_knockback(enemy_pos):
#	var push_vector = enemy_pos.direction_to(self.position)
#	move_and_slide(push_vector * KNOCKBACK_AMOUNT, Vector2.UP)
	

func heal(heal_amount):
	health += heal_amount
	
	emit_signal("healed", heal_amount)

func attack():
	if state != "Death":
		$Player_Sprite.make_attack(weapon, get_local_mouse_position().x < 0, get_local_mouse_position())
		match weapon:
			"sword":
				$Slash_Sound.play()
			"spear":
				$Slash_Sound.play()
			"claws":
				$Slash_Sound.play()
			"shuriken":
				$Shuriken_Sound.play()
			"shield":
				$Shield_Sound.play()
			"flamethrower":
				$Flamethrower_Sound.play()

func level_start():
	self.active = true
	
func level_end():
	self.active = false
	$CollisionShape2D.position = Vector2(10000, 10000)
	self.state = "Idle"
	self.weapon = "none"
	$Player_Sprite.change_state("Idle", moving_left)
	
	get_parent().get_node("Music").playing = false
	$Level_Win.play()
	
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, $Camera2D.zoom/1.5, 3.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$UI_Layer/Transition.transition()
	yield($UI_Layer/Transition, "done_transition")
	emit_signal("done_transitioning")
