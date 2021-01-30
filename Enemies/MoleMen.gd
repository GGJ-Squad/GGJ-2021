extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var weapon = "Sword"
var actor = self
var rotate
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached = false
var actor_velocity: Vector2= Vector2.ZERO
var speed = 30
var state ="Wander"
var wander_range = 200
onready var wander_timer = $WanderTimer



onready var target = get_tree().get_nodes_in_group("Players")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
	var random_x = rand_range(-wander_range,wander_range)
	var random_y = rand_range(-wander_range,wander_range)
	patrol_location = Vector2(random_x,random_y) + global_position
	actor_velocity = actor.global_position.direction_to(patrol_location) * speed
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
	

func wander(delta):
	if not patrol_location_reached:
		actor.move_and_slide(actor_velocity)
		if actor.global_position.distance_to(patrol_location) < 4:
			patrol_location_reached = true
			actor_velocity = Vector2.ZERO
			wander_timer.start()
		

func alert(delta):
	pass

func attack(delta):
	pass

func freeze(delta):
	pass

func look(delta):
	pass


func _on_Ai_state_changed(state):
	self.state = state
	if state == "Wander":
		randomize()
		var random_x = rand_range(-wander_range,wander_range)
		var random_y = rand_range(-wander_range,wander_range)
		patrol_location = Vector2(random_x,random_y) + global_position
		actor_velocity = actor.global_position.direction_to(patrol_location) * speed
		


func _on_WanderTimer_timeout():
	patrol_location_reached = false
	if state == "Wander":
		randomize()
		var random_x = rand_range(-wander_range,wander_range)
		var random_y = rand_range(-wander_range,wander_range)
		patrol_location = Vector2(random_x,random_y) + global_position
		actor_velocity = actor.global_position.direction_to(patrol_location) * speed


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_damage"):
		health -= target.get_weapon_damage()
		print("health")
		if health <= 0:
			target.change_weapon(weapon)
			queue_free()
