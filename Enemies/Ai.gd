extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var look_timer = $LookTimer
var state ="Wander"
var health = 20
var target
signal state_changed(state,body)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Alert_body_entered(body):
	if body.is_in_group("Players"):
		
		state="Alert"
		target=body
		emit_signal("state_changed",state,body)


func _on_Alert_body_exited(body):
	if body.is_in_group("Players"):
		state="Look"
		emit_signal("state_changed",state,body)
		look_timer.start()

func _on_Attack_Range_body_entered(body):
	if body.is_in_group("Players"):
		state="Attack"
		emit_signal("state_changed",state,body)

func _on_Attack_Range_body_exited(body):
	if body.is_in_group("Players"):
		state="Alert"
		emit_signal("state_changed",state,body)





func _on_LookTimer_timeout():
	if state=="Look":
		state="Wander"
		emit_signal("state_changed",state,null)
