extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state ="Wander"
var health = 100
var weapon = "Sword"
var actor = self
var rotate
var origin: Vector2 = global_position
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached = false
var actor_velocity: Vector2= Vector2.ZERO
var speed = 100
onready var target = get_tree().get_nodes_in_group("Players")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
		

func alert(delta):
	rotation = lerp(actor.rotation, actor.global_position.direction_to(target.global_position.angle()),0.2)

func attack(delta):
	rotation = lerp(actor.rotation, actor.global_position.direction_to(target.global_position.angle()),0.2)

func freeze(delta):
	pass

func look(delta):
	pass


func _on_Ai_state_changed(updated_state):
	state = updated_state
	if state == "Wander":
		var wander_range = 50
		var random_x = rand_range(-wander_range,wander_range)
		var random_y = rand_range(-wander_range,wander_range)
		patrol_location = Vector2(random_x,random_y) + origin
		actor_velocity = actor.global_position.direction_to(patrol_location) * speed
		


func _on_WanderTimer_timeout():
	pass # Replace with function body.


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_damage"):
		health -= target.get_weapon_damage()
		print("health")
		if health <= 0:
			target.change_weapon(weapon)
			queue_free()
