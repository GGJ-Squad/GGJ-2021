extends Node2D

var active = false

var cooldown = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	if get_parent().weapon == "shuriken":
		active = true
		
		cooldown = max(0, cooldown - delta)
	else:
		active = false


func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
			if get_parent().get_parent() != null:
				cooldown = 0.12
				
				var inst = load("Player/Shuriken.tscn").instance()
				var mouse_pos = get_parent().get_local_mouse_position()
				
				inst.vel = mouse_pos.normalized() * 150
				inst.position += mouse_pos.normalized() * 10 + get_parent().position
				
				get_parent().get_parent().add_child(inst)
				get_parent().attack()
