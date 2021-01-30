extends Sprite

var enemies_in_range = []

var cooldown = 0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon == "sword":
		visible = true
		active = true
		
		if cooldown > 0:
			cooldown = max(cooldown - delta, 0)
			
			if cooldown == 0:
				for c in get_parent().get_children():
					if c.name == "weapon_area": c.queue_free()
	else:
		visible = false
		active = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
				var area = Area2D.new()
				var col_shape = CollisionShape2D.new()
				col_shape.shape = CircleShape2D.new()
				col_shape.shape.radius = 9
				area.name = "weapon_area"
				area.add_to_group("player_damage")
				
				var mouse_pos = get_parent().get_local_mouse_position()
				
				area.position += mouse_pos.normalized() * 16
				
				get_parent().add_child(area)
				area.add_child(col_shape)
				
				cooldown = 0.5
	
