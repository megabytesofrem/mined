module engine.core.camera;

import gl3n.math;
import gl3n.linalg;

import bindbc.opengl;

float toRadians(float degrees) pure
{
    import std.math.constants : PI;

    return sin(degrees * (PI / 180));
}

struct Camera
{
    // Constant values for the front and up vectors

    public vec3 position = vec3(0.0, 0.0, 3.0);
    public vec3 front = vec3(0.0, 0.0, -1.0);
    public vec3 up = vec3(0.0, 1.0, 0.0);

    private mat4 _proj, _view;

    public @property mat4 projection()
    {
        return this._proj;
    }

    public @property mat4 view()
    {
        return this._view;
    }

    public this(float fov, float width, float height)
    {
        this._proj = mat4.perspective(width, height, fov.toRadians, 0.1f, 100.0f);

        // Set the view matrix to point up from 0,0,0 by default
        lookAt(vec3(4, 3, 3), vec3(0, 0, 0), vec3(0, 1, 0));
    }

    /**
     Create a view matrix from looking at a target from the camera position
     */
    public void lookAt(vec3 eye, vec3 target, vec3 up)
    {
        this._view = mat4.look_at(eye, target, up);
    }

    public void lookAtCamera()
    {
        lookAt(position, position + front, up);
    }
}