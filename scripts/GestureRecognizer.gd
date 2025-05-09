extends Node

signal flick_detected(direction: String)

@export var controller_node_path: NodePath
@export var debug_label_path: NodePath
@export var camera_node_path: NodePath
var camera: XRCamera3D

var controller: XRController3D
var debug_label: Label3D

const FLICK_SPEED_THRESHOLD := 2.0
const FLICK_LOCK_TIME := 0.25
const COOLDOWN_TIME := 0.5
const TILT_CHECK_INTERVAL := 0.1
const TILT_TRIGGER_ANGLE := 0.6

var last_position: Vector3
var cooldown_timer := 0.0
var flick_lock_timer := 0.0
var tilt_check_timer := 0.0
var grip_held := false

const GRIP_BUTTON_NAME := "grip_click"

func _ready():
	controller = get_node(controller_node_path)
	debug_label = get_node(debug_label_path)
	camera = get_node(camera_node_path)
	last_position = controller.global_transform.origin

	controller.button_pressed.connect(_on_button_pressed)
	controller.button_released.connect(_on_button_released)

func _physics_process(delta):
	if not controller or not grip_held:
		return

	if flick_lock_timer > 0:
		flick_lock_timer -= delta
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
			_trigger_flick(dir)
			return

	tilt_check_timer -= delta
	if tilt_check_timer <= 0:
		tilt_check_timer = TILT_CHECK_INTERVAL
		var tilt_dir = get_tilt_direction()
		if tilt_dir != "":
			_trigger_flick(tilt_dir)

func _trigger_flick(dir: String):
	emit_signal("flick_detected", dir)
	if debug_label:
		debug_label.text = "Gesture: " + dir
	cooldown_timer = COOLDOWN_TIME
	flick_lock_timer = FLICK_LOCK_TIME

func get_flick_direction(velocity: Vector3) -> String:
	var local_velocity = controller.global_transform.basis.inverse() * velocity

	local_velocity.z = -local_velocity.z

	var flick_vector = Vector2(local_velocity.x, local_velocity.z)

	if flick_vector.length() < 0.1:
		return ""

	if abs(flick_vector.x) > abs(flick_vector.y):
		return "right" if flick_vector.x > 0 else "left"
	else:
		return "up" if flick_vector.y < 0 else "down"

func get_tilt_direction() -> String:
	var forward = -controller.global_transform.basis.z
	forward = controller.global_transform.basis.inverse() * forward

	forward.z = -forward.z

	var angle_up = forward.angle_to(Vector3(0, 1, 0))
	if angle_up < TILT_TRIGGER_ANGLE:
		return "up"

	var angle_down = forward.angle_to(Vector3(0, -1, 0))
	if angle_down < TILT_TRIGGER_ANGLE:
		return "down"

	var angle_left = forward.angle_to(Vector3(-1, 0, 0))
	if angle_left < TILT_TRIGGER_ANGLE:
		return "left"

	var angle_right = forward.angle_to(Vector3(1, 0, 0))
	if angle_right < TILT_TRIGGER_ANGLE:
		return "right"

	return ""

func _on_button_pressed(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = true

func _on_button_released(name: String):
	if name == GRIP_BUTTON_NAME:
		grip_held = false
