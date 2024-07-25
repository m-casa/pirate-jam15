extends CharacterBody3D

var is_knocked_back: bool

var attack: Attack

# Called when a node and its children have entered the scene
func _ready():
	attack  = Attack.new()
	attack.attack_damage = 5
	
	is_knocked_back = false

func _physics_process(_delta):
	if is_knocked_back:
		# Apply friction or damping to gradually stop the knockback
		move_and_slide()
		velocity *= 0.9  # Adjust this value as needed
		
	# Stop knockback when velocity is low
	if velocity.length() < 0.1:
		is_knocked_back = false
		velocity = Vector3.ZERO

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player:
		# Unnecessary variable, only meant to understand this logic
		var player = area # If area is the player, damage them
		
		player.damage_player(attack)
