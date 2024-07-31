class_name QuestData extends Resource

@export var quest_name: String = ""
@export_multiline var quest_text: String = ""
@export var quest_turn_in: Array[SlotData]
@export var completed: bool = false
