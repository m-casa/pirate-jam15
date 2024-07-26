extends Area3D

@export var target_scene: String
@export var teleport_position: Vector3
@export var fade_duration: float = 1.0
@export var min_loading_time: float = 2.0

@onready var player = null
@onready var fade_effect = LoadingScreen

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	fade_effect.connect("fade_complete", Callable(self, "_on_fade_complete"))

func _on_body_entered(body):
	if body.name == "Player": # Caution, type sensitive
		player = body
		_start_teleport()

func _start_teleport() -> void:
	disable_controls()
	fade_effect.fade_in_with_text(fade_duration)  # Fade to black with loading text

	await get_tree().create_timer(fade_duration).timeout  # Wait for the fade-in to complete
	await get_tree().create_timer(min_loading_time).timeout  # Minimum loading time

	_teleport_player()
	fade_effect.fade_out_with_text(fade_duration)  # Fade back from black

func _teleport_player() -> void:
	if target_scene:
		var target_scene_instance = load("Scenes/" + target_scene + ".tscn").instantiate()
		get_tree().root.add_child(target_scene_instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = target_scene_instance
		
		### To Teleport to a specific position in the new scene
		# I currently haven'T figured out how to get the player node from the new scene
		# Without this script being destroyed. So I'll leave this out for now.
		
#         var new_player = target_scene_instance.get_node(player.get_path())
#         if new_player:
#             new_player.global_transform.origin = teleport_position

func disable_controls() -> void:
	if player:
		player.input_enabled = false

func enable_controls() -> void:
	if player:
		player.input_enabled = true

func _on_fade_complete() -> void:
	enable_controls()
