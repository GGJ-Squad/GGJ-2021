extends KinematicBody2D

var speed = 100

var weapon = "sword"

var side = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement(delta)

func movement(delta):
	var mouse_pos = get_local_mouse_position()
	
	if mouse_pos.x < 0:
		side = "left"
	else:
		side = "right"
	
	var dir : Vector2 = Vector2()
	
	if Input.is_action_pressed("Up"):
		dir.y -= 1
	if Input.is_action_pressed("Down"):
		dir.y += 1
	if Input.is_action_pressed("Left"):
		dir.x -= 1
	if Input.is_action_pressed("Right"):
		dir.x += 1
	
	dir = dir.normalized()
	
	move_and_slide(dir * speed, Vector2.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
