extends Node

@onready var audio_stream_player = $AudioStreamPlayer
@onready var interact = $Interact

const player_inventory: InventoryData = preload("res://Assets/PlayerData/player_inventory.tres")

signal health_updated(new_health: int)
signal onReset()
signal updateInventory
signal updateQuest
signal turnInQuest


@export_category("Intro Quest Text")
@export_group("Intro Quest Text")
@export var intro_title: String
@export_multiline var intro_text: String

@export_category("Win Text")
@export_group("Win Text")
@export var win_title: String
@export_multiline var win_text: String

# Game State Signals

#region alachemist gameplay loop
@export_category("Quest Chain")
@export var alchemist_quests: Array[QuestData]
var current_quest: QuestData:  set = set_quest
var has_seen_intro: bool = false 
var current_alachemist_state_name: String: set = set_alachemist_state
#endregion

var can_pause: bool

func _ready()-> void:
	updateQuest.connect( update_quest )
	turnInQuest.connect( complete_quest )
	can_pause = false
	
func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

#region global quest data
func set_quest(quest: QuestData) -> void:
	current_quest = quest
	
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
				if completed_quests == alchemist_quests.size():
					can_pause = false
					win_game()
					return
				continue

			if !alchemist_quests[i].completed and has_seen_intro:
				set_quest(alchemist_quests[i])
				return

func complete_quest() -> void:
	var completed_lines = 0
	if !current_quest: return
	for turnin in current_quest.quest_turn_in:
		for item in player_inventory.slots:
			if item and item.item_data == turnin.item_data and item.quantity >= turnin.quantity:
				completed_lines += 1
	
	if completed_lines == current_quest.quest_turn_in.size():
		current_quest.completed = true
		interact.play()
		steal_items()
#endregion

func steal_items() -> void:
	for i in player_inventory.slots.size():
		player_inventory.slots[i] = null

func game_over() -> void:
	steal_items()
	updateInventory.emit()
	updateQuest.emit()
	UiControls.show_game_over()
	get_tree().paused = true
	pass
	
func win_game() -> void:
	UiControls.show_win_screen()
	get_tree().paused = true
	pass
	
func reset_game() -> void:
	has_seen_intro = false
	
	for quest in alchemist_quests:
		quest.completed = false
	
	current_quest = null
	
	PlayerData.current_health = PlayerData.max_health
	pass

#region global alchemist state
func update_intro_bool() -> void:
	has_seen_intro = true
	interact.play()

func set_alachemist_state(state_name: String) -> void:
	current_alachemist_state_name = state_name
#endregion
