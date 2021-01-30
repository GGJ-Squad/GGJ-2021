extends Sprite

var enemies_in_range = []

var cooldown = 0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon == "sword":
		visible = true
		active = true
		
		if cooldown > 0:
			cooldown = max(cooldown - delta, 0)
			
			if cooldown == 0:
				get_parent().remove_weapon_hitboxes()
	else:
		visible = false
		active = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
				var mouse_pos = get_parent().get_local_mouse_position()
				
				get_parent().create_circle_hurtbox(mouse_pos.normalized() * 16, 9)
				
				cooldown = 0.5
	
