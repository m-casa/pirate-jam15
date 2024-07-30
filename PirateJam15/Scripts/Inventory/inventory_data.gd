class_name InventoryData extends Resource

@export var slots : Array[SlotData]

func _init() -> void:
	connect_slots()
	pass

func add_item(item: ItemData, count: int = 1) -> bool:
	# is the item already in a inventory slot 
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
	
	for i in slots.size():
		if slots[i] == null:
			var newSlotData = SlotData.new()
			newSlotData.item_data = item
			newSlotData.quantity = count
			slots[i] = newSlotData
			newSlotData.changed.connect(slot_changed)
			return true
		
	return false
	

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)

func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				emit_changed()
	pass
