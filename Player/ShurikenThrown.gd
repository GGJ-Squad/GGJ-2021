extends Area2D


var vel : Vector2 = Vector2()
var time = 0
const max_time = 10

var death_cd = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	rotate(delta)
	
	time += delta
	
	position += vel * delta
	
	if time >= max_time: queue_free()
	
	if death_cd > 0:
		death_cd -= delta
		if death_cd < 0: queue_free()

func _on_Area_body_entered(body):
	if not body.is_in_group("Players"): death_cd = 0.04
