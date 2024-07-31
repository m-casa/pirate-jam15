extends CharacterBody3D

@export var quests: Array[QuestData]


func _on_interactable_interacted_with():
	
	# run this at the end of intro dialog
	GameManager.update_intro_bool()
	
	GameManager.turnInQuest.emit()
	GameManager.updateInventory.emit()
	GameManager.updateQuest.emit()
