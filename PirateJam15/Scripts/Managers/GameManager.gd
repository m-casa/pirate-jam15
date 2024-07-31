extends Node

@onready var audio_stream_player = $AudioStreamPlayer
const player_inventory: InventoryData = preload("res://Assets/PlayerData/player_inventory.tres")

signal updateInventory
signal updateQuest
signal turnInQuest

# Game State Signals
signal health_updated(new_health: int)
signal onReset()

#region alachemist gameplay loop
@export var alchemist_quests: Array[QuestData]
var current_quest: QuestData:  set = set_quest
var has_seen_intro: bool = false 
var current_alachemist_state_name: String: set = set_alachemist_state
#endregion

func _ready()-> void:
	updateQuest.connect( update_quest )
	turnInQuest.connect( complete_quest )
	
func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

#region global quest data
func set_quest(quest: QuestData) -> void:
	print("setting quest data")
	current_quest = quest
	print(quest.quest_name)
	
func update_quest() -> void:
	# set initial quest if empty
	if current_quest == null and has_seen_intro:
		if alchemist_quests.size() > 0:
			set_quest(alchemist_quests[0])
			

	# loop over quests and set the quest data to the first uncompleted quest
	for i in alchemist_quests.size():
		if alchemist_quests[i]:
			if alchemist_quests[i].completed:
				continue
			if !alchemist_quests[i].completed and has_seen_intro:
				set_quest(alchemist_quests[i])
				return

	# up date inventory and quest hud
	updateInventory.emit()
	pass

func complete_quest() -> void:
	if !current_quest: return
	for turnin in current_quest.quest_turn_in:
		for item in player_inventory.slots:
			if item:
				if item.quantity >= turnin.quantity:
					current_quest.completed = true
					# TODO Check for all items if we have multi quest turn ins
					
#endregion

#region global alchemist state
func update_intro_bool() -> void:
	has_seen_intro = true

func set_alachemist_state(state_name: String) -> void:
	current_alachemist_state_name = state_name
#endregion
