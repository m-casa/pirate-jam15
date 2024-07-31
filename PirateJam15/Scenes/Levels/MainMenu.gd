extends Node2D

@onready var scene_transitioner = get_node("DoorwayTeleporter")
func _on_play_pressed():
	scene_transitioner.transition_to_scene("Basement/basement")
	pass

func _on_quit_pressed():
	get_tree().quit()
	pass
