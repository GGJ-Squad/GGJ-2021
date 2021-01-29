extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state ="Wander"
var health = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	var target = get_tree().get_nodes_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



#handle hit is a filler till i have a unique method on the player
func _on_Enemy_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()



func take_damage(damage):
	health -=damage

func wander():
	state = "Wander"

func alert():
	state = "Alert"

func attack():
	state = "Attack"
	
func runaway():
	state="Run"
	
func freeze():
	state="Freeze"
	
func look():
	state="Look"

func _on_Alert_body_entered(body):
	pass # Replace with function body.


func _on_Alert_body_exited(body):
	if body.has_method("handle_hit"):
		look()
