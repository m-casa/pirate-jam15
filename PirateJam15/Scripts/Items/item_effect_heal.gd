class_name ItemEffectHeal extends ItemEffect

@export var heal_amount: int = 1
@export var heal_sound: AudioStream
@export var player_data: PlayerData

func use() -> void:
	player_data.heal(heal_amount)
	if heal_sound: 
		GameManager.play_audio(heal_sound)
