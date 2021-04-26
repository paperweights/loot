shader_type canvas_item;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	color.a = 1.0 - color.a;
	COLOR = color;
}