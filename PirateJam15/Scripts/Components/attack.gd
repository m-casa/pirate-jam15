extends Area3D


var _can_attack: bool
var _attacking: bool
var _attack_time: float

var _slash: Node3D
var _attack_area: CollisionShape3D
var _timer: Timer

# Called when a node and its children have entered the scene
func _ready():
	# Get the gravity from project settings to be synced with RigidBody nodes
	_can_attack = true
	_attacking = false
	_attack_time = 0.3
	
	_slash = $Slash
	_attack_area = $CollisionShape3D
	_timer = $Timer
	
	_attack_area.set_disabled(true)

# Called every physics tick; 60 times per sec by default
func _physics_process(_delta):
	_attack()

# Attack only happens on collision layer 4
func _attack():
	if Input.is_action_just_released("action") && _can_attack:
		_slash.get_node("AnimationPlayer").play("slash")
		_can_attack = false
		_attacking = true
		_attack_area.set_disabled(false)
		
		_timer.set_wait_time(_attack_time)
		_timer.start()

func _on_timer_timeout():
	if _attacking:
		_attacking = false
		_can_attack = true
		_attack_area.set_disabled(true)
