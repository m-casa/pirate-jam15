@tool
class_name ItemPickup extends Node3D

@export var item_data: ItemData: set = set_item_data

@onready var area_3d: Area3D = $Area3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_3d.body_entered.connect( _on_body_entered )

func _on_body_entered(b) -> void:
	if b is Player:
		if item_data:
			if item_data.effects.size() > 0:
				for e in item_data.effects:
					if e: e.use()
				item_picked_up()
				return
			if GameManager.player_inventory.add_item( item_data ):
				item_picked_up()
	pass
	
func item_picked_up() -> void:
	area_3d.body_entered.disconnect( _on_body_entered )
	audio_player.play()
	visible = false
	GameManager.updateInventory.emit()
	await audio_player.finished
	queue_free()
	pass

func set_item_data( value: ItemData) -> void:
	item_data = value
	_update_texture()
	pass
	
func _update_texture() -> void:
	if item_data and sprite_3d:
		sprite_3d.texture = item_data.texture
	pass
