class_name HitBox extends Area3D

@export var _health_component: Health
@export var _is_enemy: bool

func damage_target(attack: Attack):
	# Check if our health component is set
	if _health_component:
		if _is_enemy:
			_health_component.damage_enemy(attack)

func damage_player(attack: Attack):
	# Check if our health component is set
	if _health_component:
		_health_component.damage_player(attack)
