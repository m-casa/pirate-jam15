extends Control

@onready var game_over_screen = $GameOverScreen

func show_game_over() -> void:
	game_over_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_game_over() -> void:
	game_over_screen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
