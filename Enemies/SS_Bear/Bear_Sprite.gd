extends AnimatedSprite

var state = "Idle"
var is_flipped = false
var is_attacking = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"

func change_state(state, flipped):
	self.state = state
	if state == "Attack":
		self.flip_h = not flipped
	else:
		self.flip_h = flipped
	if state == "Attack" and not is_attacking:
		is_attacking = true
	if not is_attacking:
		self.animation = state
	else:
		self.animation = "Attack"
	is_flipped = flipped
	


func _on_Bear_Sprite_animation_finished():
	if self.animation == "Attack":
		is_attacking=false
		self.state = "Move"
		self.animation = state
