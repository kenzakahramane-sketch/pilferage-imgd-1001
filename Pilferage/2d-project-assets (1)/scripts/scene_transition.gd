extends CanvasLayer

@onready var transition = $Transition

func _ready():
	var material = transition.material as ShaderMaterial
	material.set_shader_parameter("circle_radius", 1.5)

func iris_close():
	print("IRIS CLOSE")

	var material = transition.material as ShaderMaterial

	var cat = get_tree().current_scene.get_node_or_null("cat")

	if cat == null:
		cat = get_tree().current_scene.get_node_or_null("hubCat")
	var viewport_size = get_viewport().get_visible_rect().size
	var center = Vector2(0.5, 0.5)

	if cat != null:
		var screen_position = cat.get_global_transform_with_canvas().origin
		screen_position.x += 50
		center = screen_position / viewport_size

	material.set_shader_parameter("circle_center", center)
	material.set_shader_parameter("circle_radius", 1.5)

	var tween = create_tween()

	tween.tween_method(
		func(value): material.set_shader_parameter("circle_radius", value),
		1.5,
		-0.1,
		0.8
	)

	await tween.finished


func iris_open():
	print("IRIS OPEN")
	var material = transition.material as ShaderMaterial

	while get_tree().current_scene == null:
		await get_tree().process_frame

	var current_scene = get_tree().current_scene

	var cat = current_scene.get_node_or_null("cat")

	if cat == null:
		cat = current_scene.get_node_or_null("hubCat")

	if cat != null:
		var screen_position = cat.get_global_transform_with_canvas().origin
		screen_position.x += 50
		var viewport_size = get_viewport().get_visible_rect().size
		var center = screen_position / viewport_size

		material.set_shader_parameter("circle_center", center)

	material.set_shader_parameter("circle_radius", -0.1)

	var tween = create_tween()
	tween.tween_method(
		func(value): material.set_shader_parameter("circle_radius", value),
		-0.1,
		1.5,
		0.8
	)

	await tween.finished


func change_scene(scene_path: String):
	print("STARTING TRANSITION")
	await iris_close()
	print("CLOSED - CHANGING SCENE")

	get_tree().change_scene_to_file(scene_path)

	while get_tree().current_scene == null:
		await get_tree().process_frame

	await get_tree().process_frame

	print("NEW SCENE LOADED - OPENING")
	await iris_open()
	print("TRANSITION FINISHED")
