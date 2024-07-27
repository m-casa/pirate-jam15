class_name DropData extends Resource

@export var item : ItemData

@export_range(0, 100, 1, "suffix:%") var drop_probability: float = 100
@export_range(1, 5, 1, "suffix:items") var min_items: int = 1
@export_range(1, 5, 1, "suffix:items") var max_items: int = 1

func get_drop_count() -> int:
	if randf_range(0, 100) >= drop_probability:
		return 0

	return randi_range(min_items, max_items)
