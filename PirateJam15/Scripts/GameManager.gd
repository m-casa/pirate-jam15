extends Node

signal updateInventory

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		print('inventory')
		updateInventory.emit()
