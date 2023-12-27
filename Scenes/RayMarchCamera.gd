extends Camera3D

@export var Screen : Panel;

var _dirty : bool = false;
var viewport_size : Vector2i;
var mouse_motion : Vector2;
var paused : bool = true;

func _ready() -> void:
	get_viewport().size_changed.connect(self._border_size_changed);
	_border_size_changed();
	pass

func _border_size_changed():
	viewport_size = get_viewport().size;
	_dirty = true;
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mm = event as InputEventMouseMotion;
		mouse_motion += mm.relative;
	pass

func _process(delta: float) -> void:
	var mat : ShaderMaterial;
	
	var move : Vector3;
	move.x -= Input.get_action_strength("move_left");
	move.x += Input.get_action_strength("move_right");
	move.z -= Input.get_action_strength("move_forward");
	move.z += Input.get_action_strength("move_backward");
	move = move.normalized().rotated(Vector3.UP, deg_to_rad(rotation_degrees.y));
	
	if Input.is_action_just_pressed("pause"):
		paused = !paused;
		
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
	if paused == false:
		_dirty = true;
		position += move * 0.025 * delta * 60.0;
		rotation_degrees.y -= mouse_motion.x * 0.125 * delta * 60.0;
	
	mouse_motion = Vector2.ZERO;
	
	if Screen && _dirty:
		mat = (Screen.material as ShaderMaterial);
		mat.set_shader_parameter("nw_origin", project_ray_origin(Vector2(0.0, 0.0)));
		mat.set_shader_parameter("ne_origin", project_ray_origin(Vector2(viewport_size.x, 0.0)));
		mat.set_shader_parameter("se_origin", project_ray_origin(viewport_size));
		mat.set_shader_parameter("sw_origin", project_ray_origin(Vector2(0.0, viewport_size.y)));
		
		mat.set_shader_parameter("nw_bearing", project_ray_normal(Vector2(0.0, 0.0)));
		mat.set_shader_parameter("ne_bearing", project_ray_normal(Vector2(viewport_size.x, 0.0)));
		mat.set_shader_parameter("se_bearing", project_ray_normal(viewport_size));
		mat.set_shader_parameter("sw_bearing", project_ray_normal(Vector2(0.0, viewport_size.y)));
		_dirty = false;
	pass
