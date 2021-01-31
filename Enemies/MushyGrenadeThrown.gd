extends Area2D

var dir = Vector2()
var damage = 3
var speed = 150
var player
var time = 1.5
var kill = false
var spawned_area = false
func _ready():
	print(self.position)


func _process(delta):
	if kill:
		queue_free()
	else:
		var vel = dir * speed
		
		speed *= max(1 - delta * 2, 0.5)
		
		rotate(speed / 30 * delta)
		
		position += vel * delta
		
		time -= delta
		
		if time < 0 and not spawned_area:
			var area = Area2D.new()
			var col_shape = CollisionShape2D.new()
			col_shape.shape = CircleShape2D.new()
			col_shape.shape.radius = 32
			#area.name = "weapon_area"
			#area.add_to_group("enemy_damage")
			add_child(area)
			area.add_child(col_shape)
			spawned_area = true
			area.connect("body_entered",self,"player_damage")
		if time < -0.1:
			kill = true
func _on_Grenade_body_entered(body):
	if not body.is_in_group("Players") and not body.is_in_group("Enemy"): speed = 0
	
func start(player):
	self.player = player
func player_damage(body):
	if body.is_in_group("Players"):
		player.apply_knockback(self.position,50)
		player.take_damage(damage)

