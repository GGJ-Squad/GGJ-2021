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
				
				var area = Area2D.new()
				var col_shape = CollisionShape2D.new()
				col_shape.shape = CircleShape2D.new()
				col_shape.shape.radius = 10
				area.name = "weapon_area"
				area.add_to_group("player_damage")
				
				area.position += mouse_pos.normalized() * 8
				
				get_parent().add_child(area)
				area.add_child(col_shape)
				
			elif event.pressed == false:
				get_parent().charging = false
				
				for c in get_parent().get_children():
					if c.name == "weapon_area": c.queue_free()
