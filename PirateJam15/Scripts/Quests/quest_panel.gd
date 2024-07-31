extends Control

func _process(_delta):
	if !get_tree().paused and Input.is_action_just_pressed("toggle_quest_log"):
		visible = !visible
