module engine.renderer.chunkrenderer;

import engine.core.shader;
import engine.core.renderer;
import engine.renderer.vertex;
import engine.renderer.blockmesh;

import gl3n.math;
import gl3n.linalg;
import bindbc.opengl;

class ChunkRenderer : Renderer {
private:
    BlockMesh _mesh;

    ShaderProgram _program;
    Vertex[] _vertices;
    GLuint vao, vbo;
public:
    @property BlockMesh mesh() {
        return this._mesh;
    }

    this() {
        this.initRenderer();
    }

    override void initRenderer() {
        // generate VAO and VBO
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * _vertices.length,
            _vertices.ptr, GL_STATIC_DRAW);
    }

    override void render(ShaderProgram program) {

    }
}
