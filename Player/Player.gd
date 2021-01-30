extends KinematicBody2D

var speed = 0
var max_speed = 100

var weapon = "shuriken"

var health = 10

var charging = false
var charge_vec = Vector2()

var speed_dampening_multiplier = 5
var default_speed_dampening = 5

var last_dir = Vector2()

const target_width = 320
const target_height = 180

var attack_nudge = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rescale_camera()

func rescale_camera():
	$Camera2D.zoom.x = target_width / get_viewport().size.x
	$Camera2D.zoom.y = target_height / get_viewport().size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement(delta)

func movement(delta):
	var mouse_pos = get_local_mouse_position()
	
	var dir : Vector2 = Vector2()
	
	if charging:
		dir = charge_vec
		speed = max_speed * 1.5
		speed_dampening_multiplier = 4
		
		last_dir = dir
	else:
		if Input.is_action_pressed("Up"):
			dir.y -= 1
		if Input.is_action_pressed("Down"):
			dir.y += 1
		if Input.is_action_pressed("Left"):
			dir.x -= 1
		if Input.is_action_pressed("Right"):
			dir.x += 1
		
		dir = dir.normalized()
		
	if dir.x != 0 or dir.y != 0:
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
	
	move_and_slide(dir * speed, Vector2.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func change_weapon(new_weapon):
	weapon = new_weapon

func get_weapon_damage():
	if weapon == "sword": return 2
	if weapon == "shield": return 3
	if weapon == "claws": return 1
	if weapon == "spear": return 3
	if weapon == "shuriken": return 2
	return 1
	
func remove_weapon_hitboxes():
	for c in get_children():
		if c.name == "weapon_area": c.queue_free()

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
	col_shape.shape.extents.x = sqrt(pow((start.x - end.x), 2) + pow((start.y - end.y), 2))
	
	area.position.x += (end.x + start.x) / 2
	area.position.y += (end.y + start.y) / 2
	
	area.name = "weapon_area"
	area.add_to_group("player_damage")
	
	add_child(area)
	area.add_child(col_shape)
