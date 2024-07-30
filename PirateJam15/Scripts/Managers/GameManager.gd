extends Node

@onready var audio_stream_player = $AudioStreamPlayer
const player_inventory: InventoryData = preload("res://Assets/PlayerData/player_inventory.tres")

signal updateInventory
signal updateQuest
signal turnInQuest

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
	var completed_quests = 0

	if current_quest == null and has_seen_intro:
		if alchemist_quests.size() > 0:
			set_quest(alchemist_quests[0])

	# loop over quests and set the quest data to the first uncompleted quest
	for i in alchemist_quests.size():
		if alchemist_quests[i]:
			if alchemist_quests[i].completed:
				completed_quests += 1
				continue
			if !alchemist_quests[i].completed and has_seen_intro:
				set_quest(alchemist_quests[i])
				return

	if completed_quests == alchemist_quests.size():
		game_over()

func complete_quest() -> void:
	var completed_lines = 0
	if !current_quest: return
	for turnin in current_quest.quest_turn_in:
		for item in player_inventory.slots:
			if item and item.item_data == turnin.item_data and item.quantity >= turnin.quantity:
				completed_lines += 1

	if completed_lines == current_quest.quest_turn_in.size():
		current_quest.completed = true
		steal_items()
#endregion

func steal_items() -> void:
	for i in player_inventory.slots.size():
		player_inventory.slots[i] = null

func game_over() -> void:
	pass

#region global alchemist state
func update_intro_bool() -> void:
	has_seen_intro = true

func set_alachemist_state(state_name: String) -> void:
	current_alachemist_state_name = state_name
#endregion
