extends Node

func _ready():
	OS.window_size = OS.get_screen_size()
	OS.window_fullscreen = true
