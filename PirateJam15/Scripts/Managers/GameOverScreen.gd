extends Control

var basementScene = preload("res://Scenes/Levels/Basement/basement.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var button = $ColorRect/VBoxContainer/Button

#func _on_button_button_down():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(basementScene)
	#UiControls.hide_game_over()
	#GameManager.emit_signal("health_updated", PlayerData.max_health)


func _on_button_pressed():
	button.disabled = true
	audio_stream_player_2d.play()
	await get_tree().create_timer(.6).timeout
	get_tree().paused = false
	get_tree().change_scene_to_packed(basementScene)
	UiControls.hide_game_over()
	PlayerData.current_health = PlayerData.max_health
	GameManager.emit_signal("health_updated", PlayerData.max_health)
	GameManager.can_pause = true
