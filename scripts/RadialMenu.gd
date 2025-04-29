# RadialMenu.gd
extends Node3D

@export var slot_count: int = 8
@export var radius: float = 0.3
@export var puzzle_piece_scene: PackedScene

var slots: Array = []
var direction_to_slot := {
	"down": 0,
	"bottom right": 1,
	"right": 2,
	"upper right": 3,
	"up": 4,
	"upper left": 5,
	"left": 6,
	"bottom left": 7
}
var selected_index: int = -1

func _ready():
	visible = false
	spawn_slots()

func spawn_slots():
	for i in range(slot_count):
		var slot = Label3D.new()
		slot.text = "Slot %d" % i
		slot.scale = Vector3(0.2, 0.2, 0.2)  # Smaller size
		slot.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		slot.modulate = Color(1, 1, 1)  # Default white
		add_child(slot)
		slots.append(slot)

		var angle = i * (360.0 / slot_count)
		var radians = deg_to_rad(angle)

		var x = radius * sin(radians)
		var z = radius * cos(radians)

		slot.position = Vector3(x, 0, z)

func _on_flick_detected(direction: String):
	if not visible:
		return

	if direction in direction_to_slot:
		selected_index = direction_to_slot[direction]
		highlight_slot(selected_index)

func highlight_slot(index: int):
	for i in range(slots.size()):
		slots[i].modulate = Color(1, 1, 1)  # Reset all

	if index >= 0 and index < slots.size():
		slots[index].modulate = Color(0, 1, 0)  # Green highlight

func confirm_selection():
	if selected_index == -1:
		return  # No flicked selection

	if selected_index == 7:
		# Slot 7 = Close menu
		visible = false
		selected_index = -1
	else:
		# Otherwise, spawn the piece (coming next!)
		# spawn_puzzle_piece(selected_index)
		visible = false
		selected_index = -1
