module engine.core.camera;

import gl3n.math;
import gl3n.linalg;

import bindbc.opengl;

/// Constant values for front and up vectors
vec3 cameraFront = vec3(0, 0, -1);

/// ditto
vec3 cameraUp = vec3(0, 1, 0);

float toRadians(float degrees) pure {
    import std.math.constants : PI;

    return sin(degrees * (PI / 180));
}

struct Camera {
private:
    mat4 _proj, _view;
public:
    // Constant values for the front and up vectors
    vec3 position = vec3(0.0, 0.0, 3.0);

    @property mat4 projection() {
        return this._proj;
    }

    @property void projection(mat4 matrix) {
        this._proj = matrix;
    }

    @property mat4 view() {
        return this._view;
    }

    this(float fov, float width, float height) {
        this._proj = mat4.perspective(width, height, fov, 0.1f, 100.0f);

        auto origin = this.position; // camera is at 4,3,3 in world space
        auto target = vec3(0, 0, 0); // and looks at the origin

        // Set the view matrix to point up from 0,0,0 by default
        lookAt(origin, target, cameraUp);
    }

    /**
        Create a view matrix from looking at a target from the camera position
     */
    void lookAt(vec3 eye, vec3 target, vec3 up) {
        this._view = mat4.look_at(eye, target, cameraUp);
    }

    void lookAtCamera() {
        lookAt(position, position + cameraFront, cameraUp);
    }

    // Utility methods
    // public vec2 windowToNDC(vec3 pos, vec2 windowSize) {
    //     // convert from window space to NDC
    //     vec2 ndcPos = vec2(pos.xy / windowSize.xy) * vec2(2.0) - vec2(1.0);
    //     return ndcPos;
    // }
}
