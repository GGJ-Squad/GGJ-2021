extends KinematicBody2D


var vel : Vector2 = Vector2()
var time = 0
const max_time = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	rotate(delta)
	
	time += delta
	
	vel = move_and_slide(vel)
	
	if vel == Vector2() or time >= max_time: queue_free()
