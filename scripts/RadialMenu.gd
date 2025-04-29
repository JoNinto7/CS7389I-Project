extends Node3D

@export var slot_count: int = 4
@export var radius: float = 0.3
@export var instruction_label_path: NodePath
var instruction_label: Label3D
@export var slot_labels := [
	"Restart",
	"Exit",
	"Back",
	"Instructions"
]

var slots: Array = []
var direction_to_slot := {
	"down": 0,
	"right": 1,
	"up": 2,
	"left": 3
}
var selected_index: int = -1

func _ready():
	visible = false
	spawn_slots()
	
	if instruction_label_path != NodePath():
		instruction_label = get_node(instruction_label_path)

func spawn_slots():
	var slot_directions = {
		0: 180,
		1: 90,
		2: 0,
		3: 270
	}

	for i in range(slot_count):
		var slot = Label3D.new()
		slot.text = slot_labels[i] if i < slot_labels.size() else "Slot %d" % i
		slot.scale = Vector3(0.2, 0.2, 0.2)
		slot.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		slot.modulate = Color(1, 1, 1)
		add_child(slot)
		slots.append(slot)

		var angle = slot_directions.get(i, i * (360.0 / slot_count))
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
		slots[i].modulate = Color(1, 1, 1)

	if index >= 0 and index < slots.size():
		slots[index].modulate = Color(0, 1, 0)

func confirm_selection():
	if selected_index == -1:
		return

	match selected_index:
		0:
			restart_game()
		1:
			exit_game()
		2:
			back()
		3:
			show_instructions()

	selected_index = -1
	visible = false

func restart_game():
	get_tree().reload_current_scene()

func exit_game():
	get_tree().quit()

func back():
	pass

func show_instructions():
	if instruction_label:
		instruction_label.visible = not instruction_label.visible
