extends Control

var basementScene = preload("res://Scenes/Levels/Basement/basement.tscn")

func _on_button_button_down():
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().change_scene_to_packed(basementScene)
	UiControls.hide_win_screen()
	GameManager.updateQuest.emit()
	pass # Replace with function body.
