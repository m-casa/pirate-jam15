extends Node

@export var lerp_duration: float = 0.5
@export var lerp_step: float = 0.01

var health_bar: ProgressBar
var max_health: int = 10

func _ready():
	health_bar = $VBoxContainer/Health
	# Connect the signal to the method
	GameManager.connect("health_updated", _on_health_updated)
	GameManager.connect("onReset", _on_reset)

func _on_reset():
	health_bar.value = 100
	max_health = PlayerData.get_max_health()
	_on_health_updated(PlayerData.get_current_health())

func _on_health_updated(new_health: int):
	# Due to my limited knowledge, I fetch it everytime
	max_health = PlayerData.get_max_health()
	
	# $HealthLabel.text = str(new_health)
	# health_bar.value = ((new_health as float/max_health as float)*100) as int
	_start_lerp(((new_health as float/max_health as float)*100) as int)

func _start_lerp(target_value: float) -> void:
	var current_value = health_bar.value
	var start_time = Time.get_ticks_msec()
	var end_time = start_time + lerp_duration * 1000

	while Time.get_ticks_msec() < end_time:
		if current_value == target_value:
			break
		var elapsed = Time.get_ticks_msec() - start_time
		var t = elapsed / (lerp_duration * 1000)		
		health_bar.value = (lerp(current_value, target_value, t)) as int
		await get_tree().create_timer(lerp_step).timeout
	health_bar.value = (target_value) as int
	if target_value > 98:
		health_bar.value = 100
	if health_bar.value <= 0:
		health_bar.value = 0

func lerp(a: float, b: float, t: float) -> float:
	return a + (b - a) * t
