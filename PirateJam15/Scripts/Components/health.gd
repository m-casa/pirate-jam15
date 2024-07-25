class_name Health extends Node3D


@export var _max_health = 10.0
@export var _stun_duration = 0.3
@export var _sprite = AnimatedSprite3D

var _stunned: bool
var _health: float
var _timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	_stunned = false
	_health = _max_health
	
	_timer = $Timer

func damage_enemy(attack: Attack):
	# Check if stunned, or else enemy might be hit multiple times 
	#  within a few frames of each other
	if not _stunned:
		var enemy = get_parent()
		
		_health -= attack.attack_damage
		_sprite.modulate = Color.RED
		enemy.setup_knockback(attack)
		
		_stunned = true
		_timer.set_wait_time(_stun_duration)
		_timer.start()
		
		# Start a separate timer for the enemy to regain its original color
		await get_tree().create_timer(_timer.time_left).timeout
		_sprite.modulate = Color.WHITE
	
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
