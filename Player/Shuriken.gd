extends Sprite

var active = false

var cooldown = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	if get_parent().weapon == "shuriken":
		visible = true
		active = true
		
		cooldown = max(0, cooldown - delta)
	else:
		visible = false
		active = false


func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and \
		 event.pressed == true and cooldown == 0:
			cooldown = 0.2
			
			var inst = load("Player/ShurikenThrown.tscn").instance()
			var mouse_pos = get_parent().get_local_mouse_position()
			
			inst.vel = mouse_pos.normalized() * 30
			
			get_parent().add_child(inst)
