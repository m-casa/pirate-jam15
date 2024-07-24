class_name HitBox extends Area3D

@export var health: Health

func damage(attack: Attack):
	# Check if our health component is set
	if health:
		health.damage(attack)

func damage_player(attack: Attack):
	# Check if our health component is set
	if health:
		health.damage_player(attack)
