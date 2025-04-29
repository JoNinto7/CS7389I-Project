# GestureRecognizer.gd
extends Node

signal flick_detected(direction: String)

@export var controller_node_path: NodePath
@export var debug_label_path: NodePath

var controller: XRController3D
var debug_label: Label3D

const FLICK_SPEED_THRESHOLD := 3.5
const COOLDOWN_TIME := 3.0

var last_position: Vector3
var cooldown_timer := 0.0
var grip_held := false

const GRIP_BUTTON_NAME := "grip_click"

func _ready():
	controller = get_node(controller_node_path)
	debug_label = get_node(debug_label_path)
	last_position = controller.global_transform.origin

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

func get_flick_direction(velocity: Vector3) -> String:
	var flick_vector = Vector2(-velocity.x, velocity.y)

	# Also look at Z (forward/backward movement)
	var z_movement = velocity.z

	if flick_vector.length() < 1.0 and abs(z_movement) < 1.0:
		return ""  # Too weak, ignore

	if abs(flick_vector.x) > abs(flick_vector.y) and abs(flick_vector.x) > abs(z_movement):
		# Horizontal flick
		return "right" if flick_vector.x > 0 else "left"
	elif abs(flick_vector.y) > abs(flick_vector.x) and abs(flick_vector.y) > abs(z_movement):
		# Vertical flick
		return "up" if flick_vector.y > 0 else "down"
	else:
		# Forward/backward flick
		return "up" if z_movement < 0 else "down"

func _on_button_pressed(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = true

func _on_button_released(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = false
