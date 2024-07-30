extends GridContainer

const quest_title = preload("res://Scenes/QuestsTracker/quest_title.tscn")
const quest_text = preload("res://Scenes/QuestsTracker/quest_text.tscn")
const quest_objective_label = preload("res://Scenes/QuestsTracker/quest_objective.tscn")

@export_category("Player Inventory Data")
@export var data: InventoryData

@export_category("Into Text for the Player")
@export var intro_title: String
@export_multiline var intro_text: String

func _ready() -> void:
	set_base_info(intro_title, intro_text)
	GameManager.updateQuest.connect(update_quest_tracker)

func set_base_info(title: String, text: String) -> void:
	var quest_intro_title = quest_title.instantiate()
	add_child(quest_intro_title)
	quest_intro_title.text = title

	var quest_intro_text = quest_text.instantiate()
	add_child(quest_intro_text)
	quest_intro_text.text = text
	
func update_quest_tracker() -> void:
	if !GameManager.has_seen_intro: return
	clear_ui()
		
	if GameManager.current_quest:
		set_base_info(GameManager.current_quest.quest_name, GameManager.current_quest.quest_text)
		
		var current_amount = 0
		for obj in GameManager.current_quest.quest_turn_in:
			current_amount = 0
			for item in data.slots:
				
				#check to see if we have the item in our inventory and update string
				if item and obj:
					if item.item_data == obj.item_data:
						current_amount = item.quantity

			var quest_obj_text = "- {item} {current}/{required}"
			var quest_obj = quest_objective_label.instantiate()
			add_child(quest_obj)
			quest_obj.text = quest_obj_text.format({"item": obj.item_data.name, "current": current_amount, "required": obj.quantity})
			

func clear_ui() -> void:
	for c in get_children():
		c.queue_free()
