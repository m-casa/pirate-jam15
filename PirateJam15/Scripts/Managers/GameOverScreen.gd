extends Control

var basementScene = preload("res://Scenes/Levels/Basement/basement.tscn")

#func _on_button_button_down():
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(basementScene)
	#UiControls.hide_game_over()
	#GameManager.emit_signal("health_updated", PlayerData.max_health)


func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(basementScene)
	UiControls.hide_game_over()
	GameManager.emit_signal("health_updated", PlayerData.max_health)
