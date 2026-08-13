extends Node

@export var sun_light: DirectionalLight3D
@export var world_environment: WorldEnvironment
@export var day_duration: float = 20.0
@export var debug_label: Label

@export var time_of_day: float = 0.0

func _ready() -> void:
	if sun_light:
		sun_light.rotation_degrees.x = time_of_day * 360.0

func _process(delta: float) -> void:
	time_of_day += delta / day_duration
	if time_of_day >= 1.0:
		time_of_day -= 1.0
	
	if sun_light:
		sun_light.rotation_degrees.x = time_of_day * 360.0
		_update_environment()
		debug_label.text = get_clock_time()
	
	if debug_label:
		debug_label.text = get_clock_time()

func _update_environment() -> void:
	if not sun_light:
		return
		
	var deg_x: float = sun_light.rotation_degrees.x
	
	if is_daytime(deg_x):
		var intensity = _sun_intensity(deg_x)
		sun_light.light_energy = intensity
	else:
		sun_light.light_energy = 0.0

func is_daytime(deg_x: float) -> bool:
	return deg_x > 90.0 and deg_x < 270.0
	
func is_nighttime(deg_x: float) -> bool:
	return not is_daytime(deg_x)
	
func _sun_intensity(deg_x: float) -> float:
	var normalized = (deg_x - 90.0) / 180.0
	return sin(normalized * PI)
	
func get_clock_time() -> String:
	var total_minutes: int = int(time_of_day * 24.0 * 60.0)
	var hour_24: int = total_minutes / 60
	var minute: int = total_minutes % 60
	
	var am_pm: String = "AM" if hour_24 < 12 else "PM"
	var hour_12: int = hour_24 % 12
	if hour_12 == 0:
		hour_12 = 12
	
	return "%d:%02d %s" % [hour_12, minute, am_pm]
