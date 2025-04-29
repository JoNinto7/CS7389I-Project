# GestureRecognizer.gd
extends Node

signal flick_detected(direction: String)  # Direction will now be slot name!

@export var controller_node_path: NodePath
@export var debug_label_path: NodePath

var controller: XRController3D
var debug_label: Label3D

const FLICK_SPEED_THRESHOLD := 2.0
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

	if flick_vector.length() < 1.0:
		return ""  # Too weak, ignore

	var angle = flick_vector.angle()  # In radians
	angle = rad_to_deg(angle)

	# Godot's angle 0 is to the right (x+), increases counter-clockwise
	# We'll map into 8 regions:

	if angle < 0:
		angle += 360  # Normalize

	if (angle >= 337.5 or angle < 22.5):
		return "right"
	elif (angle >= 22.5 and angle < 67.5):
		return "upper right"
	elif (angle >= 67.5 and angle < 112.5):
		return "up"
	elif (angle >= 112.5 and angle < 157.5):
		return "upper left"
	elif (angle >= 157.5 and angle < 202.5):
		return "left"
	elif (angle >= 202.5 and angle < 247.5):
		return "bottom left"
	elif (angle >= 247.5 and angle < 292.5):
		return "down"
	elif (angle >= 292.5 and angle < 337.5):
		return "bottom right"

	return ""


func _on_button_pressed(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = true

func _on_button_released(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = false
