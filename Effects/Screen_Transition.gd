extends Node2D

signal done_untransition

var square
var player
var going = false

const X_SIZE = 480
const Y_SIZE = 270

const SCALE = 32.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()
	self.connect("done_untransition", player, "level_start")
	square = $Square
	$Cover.scale = Vector2(X_SIZE, Y_SIZE)

func _input(event):
	if event is InputEventKey and not going:
		untransition()
		going = true

func transition():
	var y = 0
	while true:
		var y_index = y
		var x_index = 0
		if y > (Y_SIZE / SCALE):
			x_index = y - (Y_SIZE / SCALE)
			y_index = (Y_SIZE / SCALE)
		if x_index >= X_SIZE / SCALE:
			break
		while(y_index >= 0):
			if x_index * SCALE >= X_SIZE:
				break
			spawn_square(x_index * SCALE, y_index * SCALE)
			y_index -= 1
			x_index += 1
		yield(get_tree().create_timer(0.01), "timeout")
		y += 1

func untransition():
	$Cover.visible = false
	var y = 0
	var delay = 0
	while true:
		var y_index = y
		var x_index = 0
		if y > (Y_SIZE / SCALE):
			x_index = y - (Y_SIZE / SCALE)
			y_index = (Y_SIZE / SCALE)
		if x_index >= X_SIZE / SCALE:
			break
		while(y_index >= 0):
			if x_index * SCALE >= X_SIZE:
				break
			var new_square = square.duplicate()
			new_square.position = Vector2(x_index * SCALE + SCALE/2, y_index * SCALE + SCALE/2)
			new_square.scale = Vector2(SCALE, SCALE)
			new_square.visible = true
			self.add_child(new_square)
			$Tween.interpolate_property(new_square, "rotation_degrees", 0, 180, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
			$Tween.interpolate_property(new_square, "scale", Vector2(SCALE, SCALE), Vector2(0, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
			#	$Tween.interpolate_property(new_square, "scale", Vector2(0,0), Vector2(SCALE, SCALE), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			y_index -= 1
			x_index += 1
		delay += 0.01
		y += 1
	yield($Tween, "tween_all_completed")
	emit_signal("done_untransition")

func spawn_square(x, y):
	var new_square = square.duplicate()
	new_square.position = Vector2(x + SCALE/2, y + SCALE/2)
	new_square.scale = Vector2(SCALE, SCALE)
	new_square.visible = true
	self.add_child(new_square)
	$Tween.interpolate_property(new_square, "rotation_degrees", 0, 180, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property(new_square, "scale", Vector2(0,0), Vector2(SCALE, SCALE), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
