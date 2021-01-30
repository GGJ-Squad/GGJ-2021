extends Node2D

var active = false

var cooldown = 0

func _ready():
	pass

func _process(delta):
	if get_parent().weapon == "grenade":
		active = true
		
		cooldown = max(0, cooldown - delta)
	else:
		active = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
			if get_parent().get_parent() != null:
				cooldown = 0.8
				
				var inst = load("Player/Grenade.tscn").instance()
				var mouse_pos = get_parent().get_local_mouse_position()

				inst.dir = mouse_pos.normalized()
				
				inst.position += mouse_pos.normalized() * 10 + get_parent().position
				
				get_parent().get_parent().add_child(inst)
				get_parent().attack()
