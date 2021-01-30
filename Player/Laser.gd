extends Node2D


var active = false
var held = false
var cooldown = 0
var queue_hitbox = false

onready var raycast = get_parent().get_node("LaserRaycast")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().weapon == "laser":
		active = true
		
		if held:
			cooldown -= delta
			
			if queue_hitbox:
				queue_hitbox = false
				
				var mouse_pos = get_parent().get_local_mouse_position()
				var target_pos = mouse_pos * 200
				
				raycast.cast_to = mouse_pos * 200
				
				raycast.force_raycast_update()
				
				if raycast.get_collider() != null:
					target_pos = raycast.get_collider().position - get_parent().position
					
					target_pos = mouse_pos.normalized() * target_pos.length()
				
				get_parent().create_rectangle_hurtbox(mouse_pos.normalized() * 5, target_pos, 6)
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
