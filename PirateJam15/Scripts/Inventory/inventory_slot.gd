class_name InventorySlotUi extends Button

var slot_data: SlotData: set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	pressed.connect( item_pressed )
	
func set_slot_data(data: SlotData) -> void:
	slot_data = data
	if slot_data == null: return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)

func item_pressed() -> void:
	print("pressed")
	if slot_data:
		if slot_data.item_data:
			var was_item_used = slot_data.item_data.use()
			if was_item_used == false: return
			slot_data.quantity -= 1
			label.text = str(slot_data.quantity)
