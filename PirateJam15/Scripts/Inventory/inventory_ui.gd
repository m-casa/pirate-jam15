class_name InventoryUI extends Control

const inventory_slot = preload("res://Scenes/Inventory/inventory_slot.tscn")

@export var data: InventoryData

func _ready() -> void:
	update_inventory()
	GameManager.updateInventory.connect( update_inventory )
	data.changed.connect( update_inventory )
	
func update_inventory() -> void:
	clear_inventory()
	for item in data.slots:
		var new_slot = inventory_slot.instantiate()
		add_child(new_slot)
		new_slot.slot_data = item

func clear_inventory() -> void:
	for child in get_children():
		child.queue_free()
