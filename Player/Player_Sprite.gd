extends Node2D

var state = "Idle"
var is_flipped = false
var is_attacking = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"

func change_state(state, flipped):
	self.state = state
	self.flip_h = flipped
	if not is_attacking:
		self.animation = state
	is_flipped = flipped
	
func make_attack(weapon, flipped, mouse_pos):
	var angle = rad2deg(mouse_pos.angle())
	$Weapon_Rot_Point.rotation_degrees = angle
	$Weapon_Rot_Point/Weapon_Effects.animation = "Effect_" + weapon.capitalize()
	$Weapon_Rot_Point/Weapon_Effects.playing = true
	$Weapon_Rot_Point/Weapon_Effects.visible = true
	is_attacking = true
	self.animation = "Attack_" + weapon.capitalize()
	self.flip_h = flipped

func hurt(flipped):
	self.flip_h = flipped
	self.animation = "Hurt"


func _on_Player_Sprite_animation_finished():
	if self.animation == "Death":
		self.playing = false
	if self.animation == "Hurt":
		self.animation = state
	if self.animation.begins_with("Attack"):
		is_attacking = false
		self.animation = state
		if not get_parent().charging:
			self.flip_h = is_flipped


func _on_Weapon_Effects_animation_finished():
	$Weapon_Rot_Point/Weapon_Effects.playing = false
	$Weapon_Rot_Point/Weapon_Effects.visible = false
