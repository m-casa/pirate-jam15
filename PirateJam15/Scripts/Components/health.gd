class_name Health extends Node3D


@export var _max_health = 10.0
@export var _stun_duration = 0.3
@export var _sprite: AnimatedSprite3D
@export var _is_player: bool = false
@export var _is_spider = false
@onready var pain = $"../Pain"
@onready var death = $"../Death"

var _stunned: bool
var health: float
var _timer: Timer

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	_stunned = false
	if _is_player:
		health = PlayerData.get_current_health()
	else:
		health = _max_health
	
	_timer = $Timer

func damage_enemy(attack: Attack):
	# Check if stunned, or else enemy might be hit multiple times 
	#  within a few frames of each other
	if health > 0 and not _stunned:
		var enemy: CharacterBody3D = get_parent()
		
		_stunned = true
		health -= attack.attack_damage
		pain.play()
		_sprite.modulate = Color.RED
		
		if not _is_spider:
			enemy.setup_knockback(attack)

		if health <= 0:
			enemy.set_collision_layer_value(2, false)
			death.play()
			_sprite.play("death")
		
		_timer.set_wait_time(_stun_duration)
		_timer.start()
		
		# Start a separate timer for the enemy to regain its original color
		await get_tree().create_timer(_timer.time_left).timeout
		_sprite.modulate = Color.WHITE

func damage_player(attack: Attack):
	print("player got hit")
	if PlayerData.get_current_health() > 0 and not _stunned:
		var player = get_parent()
		
		_stunned = true
		PlayerData.take_dmg(attack)
		player.setup_knockback(attack)
		print_debug("Hit the player for 5!")
		
		if PlayerData.get_current_health() <= 0:
			print_debug("Game Over!")
		
		_timer.set_wait_time(_stun_duration)
		_timer.start()


func _on_timer_timeout():
	_stunned = false


func _on_animated_sprite_3d_animation_finished():
	if _sprite.animation == "death":
		emit_signal("died")
		get_parent().queue_free()
