class_name Player extends CharacterBody3D


var _can_attack: bool
var _can_throw: bool
var _camera: Camera3D
var _interact_ray: RayCast3D
var _hold_position: Marker3D
var _throwable: PackedScene
var _melee_area: Area3D

@export var speed: float
@export var jump_velocity: float
@export var camera_sens: float
@export var throw_force_fwrd: float
@export var throw_force_upwrd: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_can_attack = true
	_can_throw = false
	_throwable = preload("res://Scenes/Actions/throwable.tscn")
	
	_camera = $Camera3D
	_interact_ray = $Camera3D/InteractRay
	_hold_position = $Camera3D/HoldPosition
	_melee_area = $Camera3D/MeleeArea

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouseMotion: InputEventMouseMotion = event
		self.rotate_y(-mouseMotion.relative.x * camera_sens)
		_camera.rotate_x(-mouseMotion.relative.y * camera_sens)

		#var cameraClamp: Vector3 = camera.rotation
		#cameraClamp.x = clampf(camera.rotation.x, -PI / 4, PI / 4)
		#camera.rotation = cameraClamp
		_camera.rotation_degrees.x = clampf(_camera.rotation_degrees.x, -70, 70)

func _physics_process(delta):
	_apply_gravity(delta)
	
	_get_input_dir()
	
	_jump()
	
	_interact()
	
	_attack()
	
	_throw()
	
	move_and_slide()
	
	if Input.is_action_just_pressed("quit"):
		_quit_game()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func _get_input_dir():
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func _jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func _interact():
	if Input.is_action_just_pressed("interact"):
		if _interact_ray.is_colliding():
			var interactable = _interact_ray.get_collider() as Interactable
			interactable.interact()

func _attack():
	if Input.is_action_just_released("action") && _can_attack:
		if _melee_area.has_overlapping_bodies():
			for enemy in _melee_area.get_overlapping_bodies():
				enemy.take_damage()

func _throw():
	if Input.is_action_just_released("action") && _can_throw:
		var throwable_instance = _throwable.instantiate()
		
		# For just holding in place
		#_hold_position.add_child(throwable_instance)
		
		throwable_instance.position = _hold_position.global_position
		get_tree().current_scene.add_child(throwable_instance)
		
		throwable_instance.apply_central_impulse(_camera.global_transform.basis.z * throw_force_fwrd + Vector3(0, throw_force_upwrd, 0))

func take_damage():
	print_debug("OUCH THAT HURT")

func _quit_game():
	get_tree().quit()
