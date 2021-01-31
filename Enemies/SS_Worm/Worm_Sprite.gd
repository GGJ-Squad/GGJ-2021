extends AnimatedSprite

var state = "Idle"
var is_flipped = false
var is_hurting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"

func change_state(state, flipped):
	self.state = state
	self.flip_h = flipped
	if state == "Hurt" and not is_hurting:
		is_hurting = true
	if is_hurting:
		self.animation = "Hurt"
	else:
		self.animation = state
	is_flipped = flipped

func _on_Worm_Sprite_animation_inished():
	if self.animation == "Hurt":
		is_hurting=false
		self.state = "Move"
		self.animation = state
