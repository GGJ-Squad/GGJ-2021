extends Sprite

var enemies_in_range = []

var cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon == "sword":
		visible = true
		
		if cooldown > 0:
			cooldown = max(cooldown - delta, 0)
			
			if cooldown == 0:
				for c in get_parent().get_children():
					if c.name == "weapon_area": c.queue_free()
	else:
		visible = false

func _on_Sword_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies_in_range.append(body)

func _on_Sword_body_exited(body):
	if enemies_in_range.has(body):
		enemies_in_range.remove(body)

func _input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
	 event.pressed == true and cooldown == 0:
			var area = Area2D.new()
			var col_shape = CollisionShape2D.new()
			col_shape.shape = CircleShape2D.new()
			col_shape.shape.radius = 8
			area.name = "weapon_area"
			
			var mouse_pos = get_parent().get_local_mouse_position()
			
			area.position += mouse_pos.normalized() * 16
			
			get_parent().add_child(area)
			area.add_child(col_shape)
			
			cooldown = 0.5
