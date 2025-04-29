extends XRController3D

@export var radial_menu_path: NodePath
@export var gesture_recognizer_path: NodePath

var radial_menu: Node3D
var gesture_recognizer: Node

func _ready():
	radial_menu = get_node(radial_menu_path)
	gesture_recognizer = get_node(gesture_recognizer_path)

	button_pressed.connect(_on_button_pressed)
	button_released.connect(_on_button_released)

func _on_button_pressed(name: String):
	if name == "ax_button":
		if radial_menu:
			radial_menu.global_transform = self.global_transform.translated(Vector3(0, 0.2, 0))
			radial_menu.visible = true

			if gesture_recognizer and radial_menu:
				if not gesture_recognizer.flick_detected.is_connected(radial_menu._on_flick_detected):
					gesture_recognizer.flick_detected.connect(radial_menu._on_flick_detected)

func _on_button_released(name: String):
	if name == "grip_click":
		if radial_menu and radial_menu.visible:
			radial_menu.confirm_selection()
