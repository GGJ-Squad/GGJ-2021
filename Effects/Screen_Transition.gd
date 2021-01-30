extends Node2D

var square
var going = false

const SCALE = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	square = $Square

func _input(event):
	if event is InputEventKey and not going:
		transition()
		going = true

func transition():
	var y = 0
	while true:
		var y_index = y
		var x_index = 0
		if y > (1080 / SCALE):
			x_index = y - (1080 / SCALE)
			y_index = (1080 / SCALE)
		if x_index >= 1920 / SCALE:
			break
		while(y_index >= 0):
			if x_index * SCALE >= 1920:
				break
			spawn_square(x_index * SCALE, y_index * SCALE)
			y_index -= 1
			x_index += 1
		yield(get_tree().create_timer(0.01), "timeout")
		y += 1

func untransition():
	var y = 0
	var delay = 0
	while true:
		var y_index = y
		var x_index = 0
		if y > (1080 / SCALE):
			x_index = y - (1080 / SCALE)
			y_index = (1080 / SCALE)
		if x_index >= 1920 / SCALE:
			break
		while(y_index >= 0):
			if x_index * SCALE >= 1920:
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


func spawn_square(x, y):
	var new_square = square.duplicate()
	new_square.position = Vector2(x + SCALE/2, y + SCALE/2)
	new_square.scale = Vector2(SCALE, SCALE)
	new_square.visible = true
	self.add_child(new_square)
	$Tween.interpolate_property(new_square, "rotation_degrees", 0, 180, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property(new_square, "scale", Vector2(0,0), Vector2(SCALE, SCALE), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
