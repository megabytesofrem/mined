module engine.renderer.vertex;

import gl3n.math;
import gl3n.linalg;

struct Vertex
{
    /// Position
    public vec3 position;

    /// UV texture coordinates
    public vec2 texCoords;

    /**
     Construct a vertex with the position and texture coords zeroed
     */
    public static Vertex zeroed()
    {
        return Vertex(vec3(0, 0, 0), vec2(0, 0));
    }
}
