class_name StateMachine extends Node

@export var inital_state: State

var currect_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.TransitionState.connect(on_transition)
	
	if GameManager.current_alachemist_state_name.length() > 0:
		print(GameManager.current_alachemist_state_name)
		print("should not run first")
		currect_state = states.get(GameManager.current_alachemist_state_name)
	
	if GameManager.current_alachemist_state_name.length() == 0:
		GameManager.set_alachemist_state(inital_state.name)
		inital_state.enter()
		currect_state = inital_state

			
func _process(delta: float):
	if currect_state:
		currect_state.update(delta)
	pass

func _physics_process(delta: float):
	if currect_state:
		currect_state.physics_update(delta)
	pass
	
func on_transition(state: State, new_state_name: String):
	if state != currect_state: return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if currect_state: currect_state.exit()
	
	new_state.enter()
	currect_state = new_state
