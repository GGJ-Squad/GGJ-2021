extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var weapon = "trail"
var actor = self
var rotate
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached = false
var actor_velocity: Vector2= Vector2.ZERO
var speed = 40
var path = []
var state ="Wander"
var wander_range = 200
onready var wander_timer = $WanderTimer
onready var cooldown_timer = $CooldownTimer
onready var nav = get_parent().get_node("LevelNav")
var player_last_seen
var player_detected = false
var body
var damage = 1
var last_distance = 0
var cooldown = false
var moving_left = false
var previous_x


onready var target = get_tree().get_nodes_in_group("Players")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var random_x = rand_range(-wander_range,wander_range)
	var random_y = rand_range(-wander_range,wander_range)
	patrol_location = nav.get_closest_point(Vector2(random_x,random_y) + global_position)
	_update_navigation_path(actor.position, patrol_location)
	patrol_location_reached = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == "Wander":
		wander(delta)
		if not cooldown:
			
			if get_parent() != null:
				var inst = load("Enemies/SnailTrail.tscn").instance()
				cooldown_timer.start()
				cooldown=true
				inst.position = position
				inst.position.y += 8
				inst.start(target)
				get_parent().add_child(inst)
				
	if patrol_location_reached == false:
		previous_x = position.x
		move_along_path(speed*delta)
		var dir_x = (position.x - previous_x)
		if dir_x > 0:
			moving_left = true
		elif dir_x < 0:
			moving_left = false
		$Worm_Sprite.change_state("Move", moving_left)
#		print(state)
	else:
		$Worm_Sprite.change_state("Idle", moving_left)
func wander(delta):
	if not patrol_location_reached:
		if actor.global_position.distance_to(patrol_location) < 4:
			patrol_location_reached = true
			$Worm_Sprite.change_state("Idle", moving_left)
			actor_velocity = Vector2.ZERO
			wander_timer.start()

func move_along_path(distance):
	var last_point = actor.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			actor.move_and_slide(actor.position.direction_to(path[0])*speed)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	actor.position = last_point
	patrol_location_reached = true

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = nav.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	
func _on_WanderTimer_timeout():
	patrol_location_reached = false
	if state == "Wander":
		randomize()
		var random_x = rand_range(-wander_range,wander_range)
		var random_y = rand_range(-wander_range,wander_range)
		patrol_location = nav.get_closest_point(Vector2(random_x,random_y) + global_position)
		_update_navigation_path(actor.position, patrol_location)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_damage"):
		health -= target.get_weapon_damage()
		$Worm_Sprite.change_state("Hurt", moving_left)
		print("health")
		if health <= 0:
			target.change_weapon(weapon)
			queue_free()


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Players"):
		target.apply_knockback(actor.position)


func _on_CooldownTimer_timeout():
	cooldown=false
