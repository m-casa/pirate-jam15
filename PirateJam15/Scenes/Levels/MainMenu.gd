extends Node2D

@onready var scene_transitioner = get_node("DoorwayTeleporter")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var play_btn = $CanvasLayer/VBoxContainer/VBoxContainer2/PlayBtn

func _on_play_pressed():
	play_btn.disabled = true
	audio_stream_player_2d.play()
	scene_transitioner.transition_to_scene("Basement/basement")
	pass

func _on_quit_pressed():
	get_tree().quit()
	pass
