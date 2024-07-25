class_name HitBox extends Area3D

@export var health_component: Health
@export var is_enemy: bool

func damage_target(attack: Attack):
	# Check if our health component is set
	if health_component:
		if is_enemy:
			health_component.damage_enemy(attack)

func damage_player(attack: Attack):
	# Check if our health component is set
	if health_component:
		health_component.damage_player(attack)
