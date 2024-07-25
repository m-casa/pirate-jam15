class_name Health extends Node3D


@export var _max_health = 10.0
@export var _stun_duration = 0.3

var _stunned: bool
var _health: float
var _timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	_stunned = false
	_health = _max_health
	
	_timer = $Timer

func damage_enemy(attack: Attack):
	var enemy = get_parent()
	
	# Check if stunned, or else enemy might be hit multiple times 
	#  within a few frames of each other
	if _health > 0 and not _stunned:
		_health -= attack.attack_damage
		enemy.setup_knockback(attack)
		
		_stunned = true
		_timer.set_wait_time(_stun_duration)
		_timer.start()
	
	if _health <= 0:
		get_parent().queue_free()

func damage_player(attack: Attack):
	if _health > 0 and not _stunned:
		_health -= attack.attack_damage
		print_debug("Hit the player for 5!")
		
		_stunned = true
		_timer.set_wait_time(_stun_duration)
		_timer.start()
	
	if _health <= 0:
		print_debug("Game Over!")

func _on_timer_timeout():
	_stunned = false
