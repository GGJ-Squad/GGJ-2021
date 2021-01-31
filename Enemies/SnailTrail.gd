extends Area2D


var lifetime = 3
var cooldown = 0
var place_hurtbox = false
var damage = 1
var target 
func _process(delta):
	cooldown -= delta
	lifetime -= delta
	
	if lifetime <= 0: queue_free()
	
	if place_hurtbox:
		if get_parent().get_parent() != null:
			var area = Area2D.new()
			var col_shape = CollisionShape2D.new()
			col_shape.shape = CircleShape2D.new()
			col_shape.shape.radius = 5
			area.connect("body_entered",self,"player_damage")
			
			add_child(area)
			area.add_child(col_shape)
		place_hurtbox = false
	elif cooldown < 0:
		cooldown = 0.5
		place_hurtbox = true
		for c in get_children():
			if c.name == "weapon_area": c.queue_free()

func start(target):
	self.target = target
	
func player_damage(body):
	if body.is_in_group("Players"):
		target.take_damage(damage)
