extends Node2D


var active = false
var held = false
var cooldown = 0
var queue_hitbox = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().weapon == "flamethrower":
		active = true
		
		if held:
			cooldown -= delta
			
			if queue_hitbox:
				queue_hitbox = false
				
				var mouse_pos = get_parent().get_local_mouse_position()
				
				get_parent().create_rectangle_hurtbox(mouse_pos.normalized() * 5, mouse_pos.normalized() * 32, 18)
				get_parent().attack()
			elif cooldown <= 0:
				get_parent().remove_weapon_hitboxes()
				queue_hitbox = true
				cooldown = 0.2
	else:
		active = false
		held = false

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed == true:
				held = true
				cooldown = 0.5
				queue_hitbox = true
			elif event.pressed == false:
				held = false
				get_parent().remove_weapon_hitboxes()
