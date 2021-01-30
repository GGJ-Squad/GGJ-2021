extends Node2D

var state = "Idle"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"
	pass

func change_state(state, flipped):
	self.state = state
	self.animation = state
	self.flip_h = flipped
	
func make_attack(weapon, flipped):
	pass

func hurt(flipped):
	self.flip_h = flipped
	self.animation = "Hurt"


func _on_Player_Sprite_animation_finished():
	if self.animation == "Death":
		self.playing = false
	if self.animation == "Hurt":
		self.animation = state
