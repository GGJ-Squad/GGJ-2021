extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var weapon = "Claws"
var actor = self
var rotate
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached = false
var actor_velocity: Vector2= Vector2.ZERO
var speed = 30
var path = []
var state ="Wander"
var wander_range = 200
onready var wander_timer = $WanderTimer
onready var raycast_timer = $RaycastTimer
onready var raycast = $RayCast2D
onready var nav = $Navigation2D
var player_last_seen



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
	elif state == "Alert":
		alert(delta)
	elif state == "Attack":
		attack(delta)
	elif state == "Look":
		look(delta)
	if patrol_location_reached == false:
		move_along_path(speed*delta)

func wander(delta):
	if not patrol_location_reached:
		if actor.global_position.distance_to(patrol_location) < 4:
			patrol_location_reached = true
			actor_velocity = Vector2.ZERO
			wander_timer.start()
		

func alert(delta):
	if raycast.cast_to(target.global_position) == target:
		_update_navigation_path(actor.position, target.global_position)
		patrol_location_reached = false
	else:
		raycast_timer.start()
		state = "Wander"

func attack(delta):
	pass

func freeze(delta):
	pass

func look(delta):
	pass


func _on_Ai_state_changed(state,body):
	self.state = state
	if state == "Wander":
		randomize()
		var random_x = rand_range(-wander_range,wander_range)
		var random_y = rand_range(-wander_range,wander_range)
		patrol_location = nav.get_closest_point(Vector2(random_x,random_y) + global_position)
		_update_navigation_path(actor.position, patrol_location)
		patrol_location_reached = false
	elif state == "Look":
		player_last_seen = body.global_position
		_update_navigation_path(actor.position, patrol_location)
		patrol_location_reached = false
		
func move_along_path(distance):
	var last_point = actor.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			actor.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
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
		print("health")
		if health <= 0:
			target.change_weapon(weapon)
			queue_free()


func _on_Hurtbox_body_entered(body):
	patrol_location_reached = true


func _on_RaycastTimer_timeout():
	if state == "Wander":
		state == "Alert"
