shader_type spatial;
render_mode cull_front, unshaded; // cull_front рисует только заднюю сторону (обводку)

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Цвет (желтый)
uniform float outline_width : hint_range(0.0, 10.0, 0.1) = 1.0;

void vertex() {
	// Увеличиваем вершины вдоль нормалей
	vec4 clip_position = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 clip_normal = mat3(PROJECTION_MATRIX * MODELVIEW_MATRIX) * NORMAL;
	
	// Используем нормализацию для одинаковой толщины
	clip_position.xy += normalize(clip_normal.xy) * outline_width * 0.01 * clip_position.w;
	POSITION = clip_position;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}