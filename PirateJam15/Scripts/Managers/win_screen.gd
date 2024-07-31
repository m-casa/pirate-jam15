extends Control

var basementScene = preload("res://Scenes/Levels/Basement/basement.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var button = $ColorRect/VBoxContainer/Button

func _on_button_button_down():
	button.disabled = true
	audio_stream_player_2d.play()
	await get_tree().create_timer(.6).timeout
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().change_scene_to_packed(basementScene)
	UiControls.hide_win_screen()
	GameManager.updateQuest.emit()
	GameManager.can_pause = true
	pass # Replace with function body.
