extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var loading_text = $LoadingTxt

signal fade_complete

func _ready():
	color_rect.modulate.a = 0.0  # Start with the Rect and Text fully transparent
	loading_text.modulate.a = 0.0 
	loading_text.visible = false

# Fade to black with loading text
func fade_in_with_text(duration: float) -> void:
	color_rect.modulate.a = 0.0
	loading_text.modulate.a = 0.0
	loading_text.visible = true
	color_rect.visible = true

	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	tween.tween_property(loading_text, "modulate:a", 1.0, duration)

# Fade out to "normal"
func fade_out_with_text(duration: float) -> void:
	color_rect.modulate.a = 1.0
	loading_text.modulate.a = 1.0

	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	tween.tween_property(loading_text, "modulate:a", 0.0, duration)
	tween.connect("finished", Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished() -> void:
	color_rect.visible = false
	loading_text.visible = false
	emit_signal("fade_complete")
