module engine.renderer.block.blockmesh;

import engine.core.shader;
import engine.renderer.vertex;
import engine.renderer.vertexbuilder;

import gl3n.math;
import gl3n.linalg;
import bindbc.opengl;

enum BlockFace : string
{
    front = "front",
    back = "back",
    top = "top",
    bottom = "bottom",
    left = "left",
    right = "right"
}

class BlockMesh
{
    private mat4 _modelMatrix;
    private BlockFace[] _faces;

    public VertexBuilder builder;

    /// The model matrix
    public @property mat4 modelMatrix()
    {
        return this._modelMatrix;
    }

    /// The vertices in the mesh
    public @property Vertex[] vertices()
    {
        return this.builder.vertices;
    }

    /// The visible mesh faces
    public @property BlockFace[] faces()
    {
        return this._faces;
    }

    public this()
    {
        this.builder = new VertexBuilder();
    }

    public void buildFace(BlockFace face, vec3 offset)
    {
        // Build the vertices for the face
        final switch (face)
        {
            // CCW winding order
        case BlockFace.front:
            builder.push([
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 1.0)), // 0
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 1.0)), // 1
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 2

                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 1.0)), // 0
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 2
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 0.0)), // 3
            ]);
            break;
        case BlockFace.back:
            builder.push([
                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 0.0)), // 6
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 0.0)), // 5
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)), // 4

                Vertex(vec3(1, 0, 0) + offset, vec2(1.0, 1.0)), // 7
                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 0.0)), // 6
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)), // 4
            ]);
            break;
        case BlockFace.top:
            builder.push([
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 10
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 0.0)), // 9
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 1.0)), // 8

                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 1.0)), // 11
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 10
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 1.0)), // 8
            ]);
            break;
        case BlockFace.bottom:
            builder.push([
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)), // 9
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 0.0)), // 10
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)), // 11

                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)), // 12
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)), // 13
                Vertex(vec3(1, 0, 0) + offset, vec2(1.0, 1.0)), // 14
            ]);
            break;
        case BlockFace.left:
            builder.push([
                Vertex(vec3(0, 0, 0) + offset, vec2(1.0, 0.0)), // 15
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 0.0)), // 16
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 1.0)), // 17

                Vertex(vec3(0, 0, 0) + offset, vec2(1.0, 0.0)), // 15
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 1.0)), // 17
                Vertex(vec3(0, 1, 0) + offset, vec2(1.0, 1.0)), // 18
            ]);
            break;
        case BlockFace.right:
            builder.push([
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 21
                Vertex(vec3(1, 1, 0) + offset, vec2(0.0, 0.0)), // 20
                Vertex(vec3(1, 0, 0) + offset, vec2(0.0, 1.0)), // 19

                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)), // 24
                Vertex(vec3(1, 1, 1) + offset, vec2(0.0, 1.0)), // 23
                Vertex(vec3(1, 0, 0) + offset, vec2(0.0, 0.0)), // 22

            ]);
            break;
        }

        _faces ~= face;
    }
}
