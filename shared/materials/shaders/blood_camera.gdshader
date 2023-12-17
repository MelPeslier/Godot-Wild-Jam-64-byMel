shader_type canvas_item;

uniform float uv_resolution : hint_range(0.1, 25.0) = 1.0;
uniform sampler2D sample_1 : hint_default_black, repeat_enable;
uniform sampler2D sample_2 : hint_default_black, repeat_enable;
uniform sampler2D color_palette : hint_default_black;
uniform float coef : hint_range(0, 10);
uniform vec2 pos = vec2(0.5);
uniform float radius : hint_range(0.65, 1.0);
uniform float power : hint_range(0.01, 10);

float circleSDF(vec2 _uv, vec2 _pos, float _radius, float _power){
	return sqrt( pow( abs(_uv.x - _pos.x) , _power) + pow( abs(_uv.y - _pos.y), _power) ) / pow(_radius, _power);
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv *= uv_resolution;
	uv += 0.5;
	float b_1 = texture(sample_1, uv).r;
	float b_2 = texture(sample_2, uv).r;

	float circle = circleSDF(uv, pos, radius, power);
	vec3 circ = vec3(circle);
	vec4 tex = vec4( b_1 + b_2 );
	tex.rgb *= circ;
	float grey = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	vec4 colors = texture(color_palette, vec2(grey, 0.0));
	tex *= colors;
	tex.a += circle * coef;
	tex.a = tex.a - coef;
	tex.a = clamp(tex.a, 0, 1);


	COLOR = tex;

}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
