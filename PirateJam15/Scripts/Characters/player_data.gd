class_name PlayerData extends Resource

@export var max_health: int
@export var current_health: int

func heal(amount: int) -> void:
	var over_heal = current_health + amount
	if over_heal > max_health:
		current_health = max_health
	else:
		current_health += amount
	update_hud()
	pass
	
func take_dmg(amount: int) -> void:
	current_health -= amount
	update_hud()
	pass

func update_hud() -> void:
	#emmit signal to update hud with health
	pass
