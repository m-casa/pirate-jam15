class_name Player extends CharacterBody3D


#region FIELDS
var _can_attack: bool
var _can_throw: bool
var _attack_time: float
var _gravity: float
var _move_direction: Vector3
var _target_velocity: Vector3

var _camera: Camera3D
var _interact_ray: RayCast3D
var _hold_position: Marker3D
var _attack_area: CollisionShape3D
var _timer: Timer
var _cube: PackedScene

@export var speed = 5
@export var jump_velocity = 4.5
@export var camera_sens = 0.001
@export var throw_force_fwrd = -18
@export var throw_force_upwrd = 3.5
#endregion

#region METHODS
# Called when a node and its children have entered the scene
func _ready():
	# Get the gravity from project settings to be synced with RigidBody nodes
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	_move_direction = Vector3.ZERO
	_target_velocity = Vector3.ZERO
	
	_can_attack = true
	_attack_time = 0.6
	
	_can_throw = false
	_cube = preload("res://Scenes/Items/cube.tscn")
	
	_camera = $Camera3D
	_interact_ray = $Camera3D/InteractRay
	_hold_position = $Camera3D/HoldPosition
	_attack_area = $Camera3D/AttackArea/CollisionShape3D
	_timer = $Camera3D/AttackArea/Timer
	
	_attack_area.set_disabled(true)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Check for mouse motion and apply to camera
	if event is InputEventMouseMotion:
		var mouseMotion: InputEventMouseMotion = event
		
		# Rotate self so that the player's body is rotating left and right;
		#  Camera will also rotate left and right since it's a child
		self.rotate_y(-mouseMotion.relative.x * camera_sens)
		
		# Only rotate the camera up and down; Don't want player body flipping over
		_camera.rotate_x(-mouseMotion.relative.y * camera_sens)
		
		# Clamp the camera so that the player doesn't break their neck looking up and down
		_camera.rotation_degrees.x = clampf(_camera.rotation_degrees.x, -70, 70)

# Called every frame
func _process(delta):
	_get_input_dir()
	
	_jump(delta)
	
	_quit_game()

# Called every physics tick; 60 times per sec by default
func _physics_process(_delta):
	_adjust_velocity()
	
	_interact()
	
	#_attack()
	
	_throw()
	
	move_and_slide()

# Get the input direction and handle the movement/deceleration
func _get_input_dir():
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	_move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if _move_direction:
		_target_velocity.x = _move_direction.x * speed
		_target_velocity.z = _move_direction.z * speed
	else:
		_target_velocity.x = move_toward(velocity.x, 0, speed)
		_target_velocity.z = move_toward(velocity.z, 0, speed)

# If the player is trying to jump, adjust velocity; Else add gravity
func _jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_target_velocity.y = jump_velocity
	
	if not is_on_floor():
		_target_velocity.y -= _gravity * delta

# Apply the target velocity set by the player's input
func _adjust_velocity():
	velocity = _target_velocity

# Interact ony happens on collision layer 3
func _interact():
	if Input.is_action_just_pressed("interact"):
		if _interact_ray.is_colliding():
			var interactable = _interact_ray.get_collider() as Interactable
			interactable.interact()

# Attack only happens on collision layer 4
func _attack():
	if Input.is_action_just_released("action") && _can_attack:
		_can_attack = false
		
		_timer.start()
		#if _melee_area.has_overlapping_bodies():
			#for enemy in _melee_area.get_overlapping_bodies():
				#enemy.take_damage()

# To be used for potential feature: Throwing selected item
func _throw():
	if Input.is_action_just_released("action") && _can_throw:
		var throwable = _cube.instantiate()
		
		# For just holding in place
		#_hold_position.add_child(throwable)
		
		throwable.position = _hold_position.global_position
		get_tree().current_scene.add_child(throwable)
		
		throwable.apply_central_impulse(_camera.global_transform.basis.z * throw_force_fwrd + Vector3(0, throw_force_upwrd, 0))

func take_damage():
	print_debug("OUCH THAT HURT")

func _quit_game():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
#endregion


func _on_body_entered_melee_area(body):
	pass # Replace with function body.


func _on_timer_timeout():
	_can_attack = true
