extends Node3D


@export var _max_health = 10.0
var health: float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = _max_health

func take_damage(dmg: float):
	health -= dmg
	
	if health <= 0:
		get_parent().queue_free()
