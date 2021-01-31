extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_weapon(new_weapon):
	for child in get_children():
		if child.name.begins_with("Icon_"):
			child.visible = false
	get_node("Icon_" + new_weapon.capitalize()).visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
