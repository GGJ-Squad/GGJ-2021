extends Node2D

var cooldown = 0

var active = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().weapon == "spear":
		active = true
		
		if cooldown > 0:
			cooldown = max(cooldown - delta, 0)
			
			if cooldown == 0:
				get_parent().remove_weapon_hitboxes()
	else:
		active = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
				var mouse_pos = get_parent().get_local_mouse_position()
				
				get_parent().create_rectangle_hurtbox(mouse_pos.normalized() * 5, mouse_pos.normalized() * 30, 8)
				get_parent().attack()
				
				cooldown = 0.6
	
