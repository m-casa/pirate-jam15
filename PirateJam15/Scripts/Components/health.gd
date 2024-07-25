class_name Health extends Node3D


@export var _max_health = 10.0
var health: float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = _max_health

func damage_enemy(attack: Attack):
	var enemy = get_parent()
	
	if health > 0 and not enemy.is_knocked_back:
		health -= attack.attack_damage
		apply_knockback(attack)
		
		print_debug("Hit an enemy for 5!")
	
	if health <= 0:
		print_debug("Killed an enemy!")
		get_parent().queue_free()

func damage_player(attack: Attack):
	if health > 0:
		health -= attack.attack_damage
		print_debug("Hit the player for 5!")
	
	if health <= 0:
		print_debug("Game Over!")

func apply_knockback(attack: Attack):
	var enemy = get_parent()
	var direction_normalized = attack.knockback_direction
	direction_normalized.y = 0
	direction_normalized = direction_normalized.normalized()
	
	enemy.velocity = direction_normalized * -attack.knockback_force
	enemy.is_knocked_back = true
