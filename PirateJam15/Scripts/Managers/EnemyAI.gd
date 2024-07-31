extends Node3D

@onready var player = $Player
@onready var navigation_timer = $NavigationTimer
#var ready_for_nav: bool

func _ready():
	#ready_for_nav = false
	call_deferred("actor_setup")
	pass

#func _physics_process(_delta):
	#if ready_for_nav:
		#get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	navigation_timer.start()
	#ready_for_nav = true


func _on_navigation_timer_timeout():
	#if ready_for_nav:
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
	#pass # Replace with function body.
