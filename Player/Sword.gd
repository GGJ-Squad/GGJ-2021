extends Area2D

var enemies_in_range = []

var cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon == "sword":
		$Sprite.visible = true
		
		cooldown = max(cooldown - delta, 0)
	else:
		$Sprite.visible = false

func _on_Sword_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies_in_range.append(body)

func _on_Sword_body_exited(body):
	if enemies_in_range.has(body):
		enemies_in_range.remove(body)

func _input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
	 event.pressed == true and cooldown == 0:
			for e in enemies_in_range:
				e.take_damage(1)
			cooldown = 0.5
