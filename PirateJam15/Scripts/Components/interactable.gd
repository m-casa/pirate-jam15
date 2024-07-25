extends Area3D


signal interacted_with

func interact():
	interacted_with.emit()
