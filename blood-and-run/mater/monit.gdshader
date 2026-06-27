shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, unshaded;

uniform vec4 line_color : source_color = vec4(0.5, 0.5, 0.5, 1.0); // Серый цвет линий
uniform float line_count : hint_range(1.0, 1000.0) = 100.0;        // Количество линий
uniform float line_thickness : hint_range(0.0, 1.0) = 0.2;        // Толщина линии

void fragment() {
 // Используем SCREEN_UV для фиксированных линий на экране
 // Если нужно, чтобы линии двигались вместе с объектом, замени SCREEN_UV на UV
 float uv_y = SCREEN_UV.y;
 
 // В GLSL используется fract() вместо fraction()
 float fraction_val = fract(uv_y * line_count);
 
 // Формируем четкую границу для линии
 float line_mask = step(1.0 - line_thickness, fraction_val);
 
 // Задаем цвет и прозрачность
 ALBEDO = line_color.rgb;
 ALPHA = line_mask * line_color.a;
}