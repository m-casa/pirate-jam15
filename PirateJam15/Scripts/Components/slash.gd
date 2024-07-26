extends Node3D


@export var _knockback_force = -15

var attack: Attack
var _can_attack: bool
var _attack_time: float

var _attack_area: Area3D
var _slash_shape: CollisionShape3D
var _timer: Timer

# Called when a node and its children have entered the scene
func _ready():
	attack = Attack.new()
	attack.attack_damage = 5
	attack.knockback_force = _knockback_force
	attack.knockback_direction = Vector3.ZERO
	
	_can_attack = true
	_attack_time = 0.3
	
	_attack_area = $AttackArea
	_slash_shape = $AttackArea/SlashShape
	_timer = $AttackArea/Timer
	
	_slash_shape.set_disabled(true)

# Called every physics tick; 60 times per sec by default
func _physics_process(_delta):
	_attack()
	
	_check_attack_area()

# Attack area only looks for collision on layer 4
func _attack():
	if Input.is_action_just_released("action") && _can_attack:
		# Start the attack
		_can_attack = false
		_slash_shape.set_disabled(false)
		get_node("AnimationPlayer").play("slash")
		
		# Attack cooldown
		_timer.set_wait_time(_attack_time)
		_timer.start()

func _check_attack_area():
	# First frame that slash was enabled might not have detected anything,
	#  so wait until the size of the array is greater than 0
	if _attack_area.get_overlapping_areas().size() > 0:
		for _area in _attack_area.get_overlapping_areas():
			if _area is HitBox:
				var attack_point = global_transform.origin
				var enemy_position = _area.global_transform.origin
				
				attack.knockback_direction = attack_point.direction_to(enemy_position)
				_area.damage_target(attack)

func _on_timer_timeout():
	# Done attacking, so we can swing again
	_can_attack = true
	_slash_shape.set_disabled(true)
