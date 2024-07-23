class_name Enemy extends CharacterBody3D


func take_damage():
	self.queue_free()

func _on_body_entered_damage_area(body):
	var player = body as Player
	player.take_damage()
