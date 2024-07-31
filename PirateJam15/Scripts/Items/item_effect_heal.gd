class_name ItemEffectHeal extends ItemEffect

@export var heal_amount: int = 1
@export var heal_sound: AudioStream

func use() -> void:
	PlayerData.heal(heal_amount)
	if heal_sound: 
		GameManager.play_audio(heal_sound)
