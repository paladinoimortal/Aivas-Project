extends Node3D

@export var sensitivity: float = 0.05

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var current_rotation: Vector3 = get("third_person_rotation") if get("third_person_rotation") != null else Vector3.ZERO
		
		# Aplica a rotação do mouse
		var new_rotation := Vector3(
			current_rotation.x - event.relative.y * sensitivity,
			current_rotation.y - event.relative.x * sensitivity,
			0.0
		)
		
		if has_method("set_third_person_rotation"):
			call("set_third_person_rotation", new_rotation)
