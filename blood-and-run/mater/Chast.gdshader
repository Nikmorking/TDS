shader_type spatial;
render_mode depth_draw_always, cull_disabled; // depth_draw_always предотвращает баги с тенями

uniform vec4 albedo : source_color = vec4(1.0);
uniform float cutoff_y : hint_range(-1.0, 1.0) = 0.0; // Высота, по которой режем

varying vec3 local_pos;

void vertex() {
    // Получаем мировые координаты каждой вершины
    local_pos = VERTEX;
}

void fragment() {
    // Базовый цвет объекта
    ALBEDO = albedo.rgb;
    
    // Если мировая координата Y пикселя больше заданной высоты — уничтожаем пиксель
    if (local_pos.x < cutoff_y) {
        discard;
    }
}