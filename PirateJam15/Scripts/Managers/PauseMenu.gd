extends Node

var pause_menu: Control
var baseButtons: Control
var optionsPanel: Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu = $"."
	pause_menu.hide()
	
	baseButtons = $BaseButtons
	baseButtons.show()
	
	optionsPanel = $OptionsPanel
	optionsPanel.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("escape") and get_tree().root.name != "MainMenu":
		toggle_pause_menu()
	pass
		
func toggle_pause_menu():
	if pause_menu.visible:
		pause_menu.hide()
		get_tree().paused = false
		get_window().grab_focus()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		pause_menu.show()	
		optionsPanel.hide()
		baseButtons.show()		
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
	
func toggle_options_panel():
	if optionsPanel.visible:
		optionsPanel.hide()
		baseButtons.show()
	else:
		optionsPanel.show()
		baseButtons.hide()

	
	pass

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	pass

func set_fullscreen(fullscreen: bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	pass

func _on_quit_pressed():
	get_tree().quit()
	pass
