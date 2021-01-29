extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state ="Wander"

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = get_tree().get_nodes_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


