extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Level_End_Area_body_entered(body):
	var cur_level = get_tree().get_current_scene().get_name()[-1]
	print(cur_level)
	if body.is_in_group("Players"):
		get_tree().change_scene("res://Levels/Level" + str(int(cur_level) + 1) + ".tscn")
