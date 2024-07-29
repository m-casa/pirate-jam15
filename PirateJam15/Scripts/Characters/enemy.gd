extends CharacterBody3D

const pickup = preload("res://Scenes/Inventory/item_pickup.tscn")

var attack: Attack
var _was_knocked_back: bool
var _gravity: float

@onready var health = $Health
@onready var loot_spawn = $LootSpawn

@export_category("Item Drops")
@export var drops: Array[DropData]

# Called when a node and its children have entered the scene
func _ready():
	# Get the gravity from project settings to be synced with RigidBody nodes
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	attack = Attack.new()
	attack.attack_damage = 5
	
	_was_knocked_back = false
	
	health.died.connect( drop_items )

func _physics_process(delta):
	_apply_gravity(delta)
	
	_apply_knockback()
	
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta

func setup_knockback(kncokback_attack: Attack):
	# Normalize the knockback direction,
	#  so that looking up or down doesn't change the force
	var direction_normalized = kncokback_attack.knockback_direction
	direction_normalized.y = 0
	direction_normalized = direction_normalized.normalized()
	
	velocity = direction_normalized * -kncokback_attack.knockback_force
	_was_knocked_back = true

func _apply_knockback():
	if _was_knocked_back:
		# Apply friction or damping to gradually stop the knockback
		velocity *= 0.9  # Adjust this value as needed
		
		# Stop knockback when velocity is low
		if velocity.length() < 0.1:
			_was_knocked_back = false
			velocity = Vector3.ZERO

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player:
		area.damage_player(attack)

func drop_items( position_data: Vector3) -> void:
	if drops.size() == 0: return
	for i in drops.size():
		if drops[i] == null or drops[i].item == null: continue

		var drop_count: int = drops[i].get_drop_count()

		for c in drop_count:
			var drop: ItemPickup = pickup.instantiate()
			drop.item_data = drops[i].item
			get_parent().add_child(drop)
			drop.global_position = loot_spawn.global_position
