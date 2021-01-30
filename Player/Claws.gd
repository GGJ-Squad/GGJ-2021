extends Sprite

var active = false

var cooldown = 0
var hold_time = 0

var held = false

var queue_hitbox = false

func _ready():
	pass 

func _process(delta):
	if get_parent().weapon == "claws":
		visible = true
		active = true
		
		if held:
			hold_time += delta
			cooldown -= delta
			
			if queue_hitbox:
				var mouse_pos = get_parent().get_local_mouse_position()
				
				get_parent().create_circle_hurtbox(mouse_pos.normalized() * 8, 7)
				
				queue_hitbox = false
				get_parent().attack_nudge = true
			elif cooldown <= 0:
				cooldown = max(1 / (1 + hold_time * 2), 0.1)
				
				get_parent().remove_weapon_hitboxes()
				
				queue_hitbox = true
			

	else:
		visible = false
		active = false


func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed == true:
				held = true
				hold_time = 0
				cooldown = 0.5
				queue_hitbox = true
			elif event.pressed == false:
				held = false
				get_parent().remove_weapon_hitboxes()
