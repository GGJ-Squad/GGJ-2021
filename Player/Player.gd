extends KinematicBody2D

var speed = 0
var max_speed = 100

var weapon = "claws"

var health = 10

var charging = false
var charge_vec = Vector2()

var speed_dampening_multiplier = 5
var default_speed_dampening = 5

var last_dir = Vector2()

const target_width = 320
const target_height = 180

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
	
	move_and_slide(dir * speed, Vector2.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func change_weapon(new_weapon):
	weapon = new_weapon

func get_weapon_damage():
	if weapon == "sword": return 2
	if weapon == "shield": return 3
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
