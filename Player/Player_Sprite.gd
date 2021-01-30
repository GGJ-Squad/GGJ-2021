extends Node2D

var state = "Idle"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"
	pass # Replace with function body.

func change_state(state, flipped):
	self.state = state
	self.animation = state
	self.flip_h = flipped
	
func make_attack(weapon, flipped):
	pass

func hurt(flipped):
	pass
