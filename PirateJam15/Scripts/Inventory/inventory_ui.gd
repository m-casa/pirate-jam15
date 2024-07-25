class_name InventoryUI extends Control

const inventory_slot = preload("res://Scenes/Inventory/inventory_slot.tscn")

@export var data: InventoryData



func _ready() -> void:
	update_inventory()
# hook up signal to update inventory

func clear_inventory() -> void:
	for child in get_children():
		child.queue_free()
	
func update_inventory() -> void:
	clear_inventory()
	for items in data.slots:
		var new_slot = inventory_slot.instantiate()
		print_debug(items)
		add_child(new_slot)
