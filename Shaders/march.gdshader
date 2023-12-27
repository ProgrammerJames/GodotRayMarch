shader_type canvas_item;

uniform sampler2D grid;

uniform vec3 nw_origin;
uniform vec3 nw_bearing;

uniform vec3 ne_origin;
uniform vec3 ne_bearing;

uniform vec3 se_origin;
uniform vec3 se_bearing;

uniform vec3 sw_origin;
uniform vec3 sw_bearing;

varying vec3 origin;
varying vec3 bearing;

void vertex() {
	vec3 o1 = mix(nw_origin, ne_origin, UV.x);
	vec3 o2 = mix(sw_origin, se_origin, UV.x);
	origin = mix(o1, o2, UV.y);
	
	vec3 b1 = mix(nw_bearing, ne_bearing, UV.x);
	vec3 b2 = mix(sw_bearing, se_bearing, UV.x);
	bearing = mix(b1, b2, UV.y);
}

float dist(vec3 point)
{
	//vec2 coords = point.xz/16.0;
	//return (texture(grid, coords).r*256.0);
	
	// Spheres!
	return length(mod(point+vec3(1.0, 1.0, 1.0), vec3(2.0, 2.0, 2.0))-vec3(1.0, 1.0, 1.0)-vec3(0.0, 0.0, 0.0))-0.5;
}

void fragment() {
	vec3 pos = origin;
	vec3 b = normalize(bearing);
	float dd = 0.0;
	
	for (int i=0; i<100; i++)
	{
		float d = dist(pos);
		pos += d*b;
		dd += d;
	}
	
	dd = 1.0-clamp(dd, 0.0, 10.0)/10.0;
	
	COLOR = vec4(dd, dd, dd, 1.0);
}