extends Resource
class_name Loot

@export var sprite: ItemData
@export_range(1, 5, 1, 'suffix:item') var min_amount: int
@export_range(1, 5, 1, 'suffix:item') var max_amount: int

func get_drop_amount() -> int:
	return randi_range(min_amount, max_amount)
