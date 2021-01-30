extends Node2D

var active = false

var last_distance = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().weapon == "trail":
		active = true
		
		if get_parent().distance_travelled > last_distance + 8:
			last_distance = get_parent().distance_travelled
			
			if get_parent().get_parent() != null:
				var inst = load("Player/Trail.tscn").instance()
				
				inst.position += get_parent().position
				inst.position.y += 8
				
				get_parent().get_parent().add_child(inst)
			
	else:
		active = false
