class_name Loot extends Resource

@export var item: ItemData
@export_range(1, 100, 50, 'suffix:%') var drop_chance: float
@export_range(1, 5, 1, 'suffix:item') var min_amount: int
@export_range(1, 5, 1, 'suffix:item') var max_amount: int

func get_drop_amount() -> int:
	return randi_range(min_amount, max_amount)
