extends Node3D

var snap_zones: Array[Node] = []
var instruction_label: Label3D = null
var already_completed: bool = false

func _ready():
	for child in get_children():
		if child.name.ends_with("SnapZone") and child is XRToolsSnapZone:
			snap_zones.append(child)
			child.has_picked_up.connect(_on_snap_zone_updated)
			child.has_dropped.connect(_on_snap_zone_updated)

	var parent = get_parent()
	if parent:
		instruction_label = parent.get_node_or_null("InstructionLabel")

func _on_snap_zone_updated(_what = null):
	if already_completed:
		return

	if are_all_snapzones_filled():
		already_completed = true
		if instruction_label:
			instruction_label.visible = true
			instruction_label.text = "Thank you! Press A to Restart or Exit."

func are_all_snapzones_filled() -> bool:
	for zone in snap_zones:
		if not zone.has_snapped_object():
			return false
	return true
