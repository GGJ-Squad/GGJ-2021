extends Sprite

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon == "shield":
		visible = true
		active = true
	else:
		visible = false
		active = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed == true:
				var mouse_pos = get_parent().get_local_mouse_position()
				
				get_parent().charging = true
				get_parent().charge_vec = mouse_pos.normalized()
				
				get_parent().create_circle_hurtbox(mouse_pos.normalized() * 8, 10)
				
			elif event.pressed == false:
				get_parent().charging = false
				
				get_parent().remove_weapon_hitboxes()
