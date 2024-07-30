extends CharacterBody3D

const pickup = preload("res://Scenes/Inventory/item_pickup.tscn")

@export var _knockback_force = -15

var attack: Attack
var _was_knocked_back: bool
var _gravity: float

@onready var health = $Health
@onready var loot_spawn = $LootSpawn
@onready var animated_sprite = $AnimatedSprite3D

@export_category("Item Drops")
@export var drops: Array[DropData]

# Called when a node and its children have entered the scene
func _ready():
	# Get the gravity from project settings to be synced with RigidBody nodes
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	attack = Attack.new()
	attack.attack_damage = 5
	attack.knockback_force = _knockback_force
	attack.knockback_direction = Vector3.ZERO
	
	_was_knocked_back = false
	
	health.died.connect( drop_items )

func _physics_process(delta):
	_apply_gravity(delta)
	
	_apply_knockback()
	
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= _gravity * delta

func setup_knockback(knockback_attack: Attack):
	# Normalize the knockback direction,
	#  so that looking up or down doesn't change the force
	var direction_normalized = knockback_attack.knockback_direction
	direction_normalized.y = 0
	direction_normalized = direction_normalized.normalized()
	
	velocity = direction_normalized * -knockback_attack.knockback_force
	_was_knocked_back = true

func _apply_knockback():
	if _was_knocked_back:
		# Apply friction to gradually stop the knockback
		var friction = 0.9
		
		velocity.x *= friction
		velocity.z *= friction
		
		# Stop knockback when velocity is low
		if velocity.length() < 0.7:
			_was_knocked_back = false
			velocity.x = 0
			velocity.z = 0

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player and health.health > 0:
		var enemy_position = global_transform.origin
		var player_position = area.global_transform.origin
		
		attack.knockback_direction = enemy_position.direction_to(player_position)
		area.damage_player(attack)

func drop_items() -> void:
	if drops.size() == 0: return
	for i in drops.size():
		if drops[i] == null or drops[i].item == null: continue

		var drop_count: int = drops[i].get_drop_count()

		for c in drop_count:
			var drop: ItemPickup = pickup.instantiate()
			drop.item_data = drops[i].item
			get_parent().add_child(drop)
			drop.global_position = loot_spawn.global_position
