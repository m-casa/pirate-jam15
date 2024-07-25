extends Node3D

@export var items: Array[Loot]
@onready var sprite_3d: Sprite3D = $Sprite3D


func _ready():
	var texture = items[0].item.texture
	sprite_3d.texture = texture
