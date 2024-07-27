extends Node

@onready var audio_stream_player = $AudioStreamPlayer

const player_inventory: InventoryData = preload("res://Assets/PlayerData/player_inventory.tres")

signal updateInventory

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		print('inventory')
		updateInventory.emit()

func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
