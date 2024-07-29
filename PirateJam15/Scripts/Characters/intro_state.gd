class_name IntroState extends State

var intro_dialog: String

func enter() -> void:
	print("entered intro state")
	pass
	
func exit() -> void:
	print("left intro state")
	pass

func update(delta: float) -> void:
	if GameManager.has_seen_intro:
		TransitionState.emit(self, "OnQuestState")
