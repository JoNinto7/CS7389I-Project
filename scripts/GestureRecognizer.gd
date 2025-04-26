extends Node

signal flick_detected(direction: String)

@export var controller_node_path: NodePath
@export var debug_label_path: NodePath

var controller: XRController3D
var debug_label: Label3D

const FLICK_SPEED_THRESHOLD := 2.0
const COOLDOWN_TIME := 2.0

var last_position: Vector3
var cooldown_timer := 0.0
var grip_held := false  # NEW: Track if grip is held

# Replace with your actual action name for grip if needed
const GRIP_BUTTON_NAME := "grip_click"  

func _ready():
	controller = get_node(controller_node_path)
	debug_label = get_node(debug_label_path)
	last_position = controller.global_transform.origin

	# Connect controller button events
	controller.button_pressed.connect(_on_button_pressed)
	controller.button_released.connect(_on_button_released)

func _physics_process(delta):
	if not controller or not grip_held:
		return

	if cooldown_timer > 0:
		cooldown_timer -= delta
		return

	var current_position = controller.global_transform.origin
	var velocity = (current_position - last_position) / delta

	last_position = current_position

	if velocity.length() > FLICK_SPEED_THRESHOLD:
		var dir = get_flick_direction(velocity)
		if dir != "":
			emit_signal("flick_detected", dir)
			if debug_label:
				debug_label.text = "Gesture: " + dir
			cooldown_timer = COOLDOWN_TIME
			last_position = controller.global_transform.origin

func get_flick_direction(velocity: Vector3) -> String:
	if abs(velocity.x) > abs(velocity.y) and abs(velocity.x) > abs(velocity.z):
		return "right" if velocity.x > 0 else "left"
	elif abs(velocity.y) > abs(velocity.x) and abs(velocity.y) > abs(velocity.z):
		return "up" if velocity.y > 0 else "down"
	elif abs(velocity.z) > abs(velocity.x) and abs(velocity.z) > abs(velocity.y):
		return "forward" if velocity.z < 0 else "backward"
	return ""

func _on_button_pressed(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = true

func _on_button_released(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = false
