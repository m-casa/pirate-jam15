extends Node3D


var attack: Attack

var _can_attack: bool
var _attack_time: float

var _attack_area: CollisionShape3D
var _timer: Timer

# Called when a node and its children have entered the scene
func _ready():
	attack = Attack.new()
	attack.attack_damage = 5
	attack.knockback_force = -10
	attack.knockback_direction = -global_transform.basis.z
	
	_can_attack = true
	_attack_time = 0.3
	
	_attack_area = $AttackArea/SlashShape
	_timer = $AttackArea/Timer
	
	_attack_area.set_disabled(true)

# Called every physics tick; 60 times per sec by default
func _physics_process(_delta):
	_attack()

# Attack area only looks for collision on layer 4
func _attack():
	if Input.is_action_just_released("action") && _can_attack:
		get_node("AnimationPlayer").play("slash")
		_can_attack = false
		_attack_area.set_disabled(false)
		
		_timer.set_wait_time(_attack_time)
		_timer.start()

func _on_timer_timeout():
	# Done attacking, so we can swing again
	_can_attack = true
	_attack_area.set_disabled(true)

func _on_attack_area_entered(area):
	if area is HitBox:
		# Unnecessary variable, only meant to understand this logic
		var target = area # If area is a hitbox, they're a target (enemies, pots) 
		attack.knockback_direction = -global_transform.basis.z
		
		target.damage_target(attack)
