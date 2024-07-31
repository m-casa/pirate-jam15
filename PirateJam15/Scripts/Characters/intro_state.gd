class_name IntroState extends State

var intro_dialog: String

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func update(_delta: float) -> void:
	if GameManager.has_seen_intro:
		TransitionState.emit(self, "OnQuestState")
