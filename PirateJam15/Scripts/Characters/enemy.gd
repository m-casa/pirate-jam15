extends CharacterBody3D

var attack: Attack

# Called when a node and its children have entered the scene
func _ready():
	attack  = Attack.new()
	attack.attack_damage = 5

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player:
		# Unnecessary variable, only meant to understand this logic
		var player = area # If area is the player, damage them
		
		player.damage_player(attack)
