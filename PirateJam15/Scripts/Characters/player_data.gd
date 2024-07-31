extends Node

@export var max_health: int = 30
@export var current_health: int = 30
@export var speed_bonus : float = 3
var isSpeeding : bool = false
var speedBonusTimeLeft : float
var speedBonusLength : float = 10
var end_time : float
var stunned: bool = false
var stunTimer: Timer

#@onready var player = get_node("../Basement/Player")
var player : Player
func _ready():
	FindPlayer()
	stunTimer = Timer.new()
	stunTimer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	stunTimer.one_shot = true
	stunTimer.wait_time = 0.7
	stunTimer.timeout.connect( reset_stun )
	add_child(stunTimer)

# Sooo Hacked-in... Welp.
func FindPlayer() -> void:
	var player_nodes = get_tree().get_nodes_in_group("Player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
	if player == null:
		print("Player node not found!")
	else:
		print("Player node found!")

func get_max_health() -> int:
	return max_health

func get_current_health() -> int:
	return current_health
	
func ActivateSpeedBonus() -> void:
	if isSpeeding == false:
		if !player:
			FindPlayer()
		isSpeeding = true		
		_start_speed_cooldown()
	end_time = Time.get_ticks_msec() + speedBonusLength * 1000
	


func heal(amount: int) -> void:
	var over_heal = current_health + amount
	if over_heal > max_health:
		current_health = max_health
	else:
		current_health += amount
	update_hud()
	pass
	
func take_dmg(attack: Attack) -> void:
	if current_health > 0 and not stunned:
		stunned = true
		current_health -= attack.attack_damage
		update_hud()
		FindPlayer()
		player.setup_knockback(attack)
		player.play_pain()
		
	
		if current_health <= 0:
			GameManager.can_pause = false
			current_health = 0
			player.play_death()
			player.input_enabled = false
			await get_tree().create_timer(.8).timeout
			GameManager.game_over()
			
		stunTimer.start()

func reset_stun() -> void:
	print("reset stunned")
	stunned = false

func update_hud() -> void:
	print("UPDATE HUD SIGNAL!!!!!!")
	GameManager.emit_signal("health_updated", current_health)
	#emmit signal to update hud with health
	pass
	
func _start_speed_cooldown() -> void:
	end_time = Time.get_ticks_msec() + speedBonusLength * 1000

	if player:
		player._player_speed += speed_bonus
	
	while Time.get_ticks_msec() < end_time:
		await get_tree().create_timer(0.01).timeout
	
	if player:
		FindPlayer()
		player._player_speed = 5

	isSpeeding = false
