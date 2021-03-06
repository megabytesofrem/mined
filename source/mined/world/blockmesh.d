module mined.world.blockmesh;

import mined.engine;
import mined.engine.shader;
import mined.renderer.vertex;

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
private:
    mat4 _modelMatrix;
    BlockFace[] _faces;
public:
    Vertex[] vertices;

    /// The model matrix
    @property mat4 modelMatrix()
    {
        return this._modelMatrix;
    }

    /// The visible mesh faces
    @property BlockFace[] faces()
    {
        return this._faces;
    }

    void buildFace(BlockFace face, vec3 offset)
    {
        // Build the vertices for the face
        switch (face)
        {
        case BlockFace.front:
            // dfmt off
            vertices ~= [
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 1.0)), // 0
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 1.0)), // 1
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 2
                
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 1.0)), // 0
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 2
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 0.0)), // 3
            ];
            // dfmt on
            break;
        case BlockFace.back:
            // dfmt off
            vertices ~= [
                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 0.0)),// 6
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 0.0)),// 5
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)),// 4

                Vertex(vec3(1, 0, 0) + offset, vec2(1.0, 1.0)),// 7
                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 0.0)),// 6
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)),// 4
            ];
            // dfmt on
            break;
        case BlockFace.top:
            // dfmt off
            vertices ~= [
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)),// 10
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 0.0)),// 9
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 1.0)),// 8

                Vertex(vec3(1, 1, 0) + offset, vec2(1.0, 1.0)),// 11
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)),// 10
                Vertex(vec3(0, 1, 0) + offset, vec2(0.0, 1.0)),// 8
            ];
            // dfmt on
            break;
        case BlockFace.bottom:
            // dfmt off
            vertices ~= [
                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)),// 9
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 0.0)), // 10
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)), // 11

                Vertex(vec3(0, 0, 0) + offset, vec2(0.0, 1.0)),// 12
                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)),// 13
                Vertex(vec3(1, 0, 0) + offset, vec2(1.0, 1.0)) // 14
            ];
            // dfmt on
            break;
        case BlockFace.left:
            // TODO: fix UVs so they are not mirrored on the Y axis
            // dfmt off
            vertices ~= [
                Vertex(vec3(0, 0, 0) + offset, vec2(1.0, 0.0)), // 15
                Vertex(vec3(0, 0, 1) + offset, vec2(0.0, 0.0)), // 16
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 1.0)), // 17

                Vertex(vec3(0, 0, 0) + offset, vec2(1.0, 0.0)), // 15
                Vertex(vec3(0, 1, 1) + offset, vec2(0.0, 1.0)), // 17
                Vertex(vec3(0, 1, 0) + offset, vec2(1.0, 1.0)), // 18
            ];
            // dfmt on
            break;
        case BlockFace.right:
            // TODO: fix UVs so they are not mirrored on the Y axis
            // dfmt off
            vertices ~= [
                Vertex(vec3(1, 1, 1) + offset, vec2(1.0, 0.0)), // 21
                Vertex(vec3(1, 1, 0) + offset, vec2(0.0, 0.0)), // 20
                Vertex(vec3(1, 0, 0) + offset, vec2(0.0, 1.0)), // 19

                Vertex(vec3(1, 0, 1) + offset, vec2(1.0, 0.0)), // 24
                Vertex(vec3(1, 1, 1) + offset, vec2(0.0, 1.0)), // 23
                Vertex(vec3(1, 0, 0) + offset, vec2(0.0, 0.0)), // 22

            ];
            // dfmt on
            break;
        default:
            break;
        }

        _faces ~= face;
    }
}
