extends Control

@onready var game_over_screen: Control = $GameOverScreen
@onready var win_screen: Control = $WinScreen

func show_game_over() -> void:
	game_over_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_game_over() -> void:
	game_over_screen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func show_win_screen() -> void:
	win_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_win_screen() -> void:
	win_screen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
