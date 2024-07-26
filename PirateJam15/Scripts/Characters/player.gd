class_name Player extends CharacterBody3D

### Mickplouffe: Added the following code at multiple place related to input handling.
# 	if not input_enabled:
#  		return

#region FIELDS
@export var _player_speed = 5
@export var _jump_velocity = 4.5
@export var _camera_sens = 0.001
@export var _throw_force_fwrd = -18
@export var _throw_force_upwrd = 3.5

var _jumping: bool
var _can_throw: bool
var _gravity: float
var _input_dir: Vector2
var input_enabled: bool = true  # Mickplouffe: Added this flag to control input handling

var _camera: Camera3D
var _interact_ray: RayCast3D
var _hand_position: Marker3D
var _cube: PackedScene
#endregion

#region METHODS
# Called when a node and its children have entered the scene
func _ready():
	_jumping = false
	_can_throw = false
	_input_dir = Vector2.ZERO
	
	_camera = $Camera
	_interact_ray = $Camera/InteractionRayCast
	_hand_position = $Camera/HandPosition
	
	# Get the gravity from project settings to be synced with RigidBody nodes
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	# Preload anything we plan to instantiate during gameplay
	_cube = preload("res://Scenes/Items/cube.tscn")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if not input_enabled:
		return
	# Check for mouse motion and apply to camera
	if event is InputEventMouseMotion:
		var mouseMotion: InputEventMouseMotion = event
		# Rotate self so that the player's body is rotating left and right;
		#  Camera will also rotate left and right since it's a child
		self.rotate_y(-mouseMotion.relative.x * _camera_sens)
		
		# Only rotate the camera up and down; Don't want player body flipping over
		_camera.rotate_x(-mouseMotion.relative.y * _camera_sens)
		
		# Clamp the camera so that the player doesn't break their neck looking up and down
		_camera.rotation_degrees.x = clampf(_camera.rotation_degrees.x, -70, 70)

# Called every frame
func _process(_delta):
	if not input_enabled:
		return
	_get_input_dir()
	
	_jump()
	
	_quit_game()

# Called every physics tick; 60 times per sec by default
func _physics_process(delta):
	_apply_gravity(delta)
	
	
	_apply_velocity()
	
	if not input_enabled:
		return
	_interact()
	
	_throw()
	
	move_and_slide()

# Get the input direction to handle movement/deceleration
func _get_input_dir():
	_input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")

func _jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jumping = true

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta

# Apply the movement direction set by the player's input
func _apply_velocity():
	var move_direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if move_direction:
		velocity.x = move_direction.x * _player_speed
		velocity.z = move_direction.z * _player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _player_speed)
		velocity.z = move_toward(velocity.z, 0, _player_speed)
	
	# If the player is trying to jump, adjust vertical velocity
	if _jumping:
		_jumping = false
		velocity.y = _jump_velocity

# Interact ony happens on collision layer 3
func _interact():
	if Input.is_action_just_pressed("interact"):
		if _interact_ray.is_colliding():
			var interactable = _interact_ray.get_collider()
			interactable.interact()

# To be used for potential feature: Throwing selected item
func _throw():
	if Input.is_action_just_released("action") && _can_throw:
		pass
		#var throwable = _cube.instantiate()
		
		# For just holding in place
		#_hand_position.add_child(throwable)
		
		#throwable.position = _hand_position.global_position
		#get_tree().current_scene.add_child(throwable)
		
		#throwable.apply_central_impulse(_camera.global_transform.basis.z * throw_force_fwrd + Vector3(0, throw_force_upwrd, 0))

func _quit_game():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
#endregion
