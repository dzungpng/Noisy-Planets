#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

#define SHADES 5.0



vec3 colInterp(vec3 bcol, vec3 ecol, vec3 inCol){
    float st = 1.0 / SHADES;
    float avg = inCol.x * SHADES; 
    float band = ceil(avg) / SHADES;
    return mix(bcol, ecol, band);
}

vec3 diff(vec3 c, float k, vec3 p){
    vec3 n = fs_Nor.xyz;
    vec3 l = normalize(fs_LightVec.xyz - p);
    return c * k * max(0.0, dot(n, l));
}

vec3 palette(vec3 inCol){
    vec3 mcol = vec3(0.95);
    vec3 bcol = mcol / 4.0;
    return colInterp(bcol, mcol, inCol);
}

void main()
{
    // Material base color (before shading)
        vec4 diffuseColor = u_Color;

        // // Calculate the diffuse term for Lambert shading
        // float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
        // // Avoid negative lighting values
        // // diffuseTerm = clamp(diffuseTerm, 0, 1);

        // float ambientTerm = 0.2;

        // float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
        //                                                     //to simulate ambient lighting. This ensures that faces that are not
        //                                                     //lit by our point light are not completely black.

        // Compute final shaded color

        
        out_Col = vec4(palette(diff(vec3(1.0), 1.0, diffuseColor.rgb)), diffuseColor.a);
}
