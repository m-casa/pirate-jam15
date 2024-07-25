class_name HitBox extends Area3D

@export var health: Health
@export var is_enemy: bool

func damage_target(attack: Attack):
	# Check if our health component is set
	if health:
		if is_enemy:
			health.damage_enemy(attack)

func damage_player(attack: Attack):
	# Check if our health component is set
	if health:
		health.damage_player(attack)
