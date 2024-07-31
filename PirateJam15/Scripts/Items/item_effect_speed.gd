class_name ItemEffectSpeed extends ItemEffect

@export var speed_amount: int = 1
# @export var speed_duration: int = 10
@export var speed_sound: AudioStream

func use() -> void:
	PlayerData.ActivateSpeedBonus()
	if speed_sound: 
		GameManager.play_audio(speed_sound)
