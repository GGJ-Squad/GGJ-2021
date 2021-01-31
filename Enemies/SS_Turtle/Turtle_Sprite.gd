extends AnimatedSprite

var state = "Idle"
var is_flipped = false
var is_attacking = false
var is_hurting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "Idle"

func change_state(state, flipped):
	self.state = state
	self.flip_h = flipped
	if state == "RunAttack" and not is_attacking:
		is_attacking = true
	elif state == "Hurt" and not is_hurting:
		is_hurting = true
	if is_attacking:
		self.animation = "RunAttack"
	elif is_hurting:
		self.animation = "Hurt"
	else:
		self.animation = state
	is_flipped = flipped
	

func _on_Turtle_Sprite_animation_finished():
	if self.animation == "RunAttack":
		is_attacking=false
		self.state = "Move"
		self.animation = state
	elif self.animation == "Hurt":
		is_hurting=false
		self.state = "Move"
		self.animation = state