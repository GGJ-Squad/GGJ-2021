extends Node2D

var cur_health = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	$Label.text = str(cur_health)

func heal(in_heal):
	$Tween.interpolate_property(get_node("Heart_Overlay"), "modulate", Color(0,1,0,1), Color(0,1,0,0), 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	set_health(cur_health + in_heal)

func damage(in_damage):
	set_health(cur_health - in_damage)
	var h_index = 0
	for child in self.get_children():
		if child is AnimatedSprite:
			if child.frame == 4:
				h_index += 1
				continue
	$Tween.interpolate_property(get_node("Heart_Overlay"), "modulate", Color(1,0,0,1), Color(1,0,0,0), 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	$Heart_Shards.position = Vector2(h_index * 21 + 17, 16)
	$Heart_Shards.emitting = true
	get_node("Break_Sound" + str(randi() % 3)).play()

func set_health(health):
	cur_health = health
	for child in self.get_children():
		if child is AnimatedSprite:
			child.frame = 0
	for child in self.get_children():
		if child is AnimatedSprite:
			if health > 4:
				health -= 4
				child.frame = 4
				continue
			else:
				child.frame = health
				return 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
