extends Node3D

@onready var player = $Player
var ready_for_nav: bool

func _ready():
	ready_for_nav = false
	call_deferred("actor_setup")
	pass

func _physics_process(_delta):
	if ready_for_nav:
		get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	ready_for_nav = true
