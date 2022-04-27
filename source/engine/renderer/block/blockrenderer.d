module engine.renderer.block.blockrenderer;

import engine.core.shader;
import engine.core.renderer;
import engine.renderer.vertex;
import engine.renderer.block.blockmesh;

import gl3n.math;
import gl3n.linalg;
import bindbc.opengl;

import std.stdio;
import std.conv : to;

class BlockRenderer : Renderer {
private:
    ShaderProgram _program;
    Vertex[] _vertices;

    GLuint vao, vbo;
public:
    BlockMesh mesh;
    mat4 modelMatrix;

    private ShaderProgram _program;
    private Vertex[] _vertices;

    /// Shader program to use for rendering
    public @property ShaderProgram program() {
        return this._program;
    }

    // GL internals
    private GLuint vao, vbo;

    public this() {
        const offset = vec3(0, 0, 0);
        this.modelMatrix = mat4.identity;
        this.mesh = new BlockMesh();

        // generate VAO
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // generate faces
        mesh.buildFace(BlockFace.left, offset);
        mesh.buildFace(BlockFace.right, offset);
        mesh.buildFace(BlockFace.top, offset);
        mesh.buildFace(BlockFace.bottom, offset);
        mesh.buildFace(BlockFace.front, offset);
        mesh.buildFace(BlockFace.back, offset);

        // debug
        writefln("faces: %('%s', %)", mesh.faces);
        writefln("verts: %('%s', %)", mesh.builder.vertices);

        this._vertices = mesh.builder.vertices;

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * _vertices.length,
            _vertices.ptr, GL_STATIC_DRAW);

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof,
            cast(void*) Vertex.position.offsetof);
        glEnableVertexAttribArray(0);
    }

    public void translate(vec3 position) {
        this.modelMatrix = mat4.translation(position);
    }

    public override void initRenderer() {

    }

    public override void render(ShaderProgram program) {
        writefln("program: %d", program.program);

        program.use;

        glDrawArrays(GL_TRIANGLES, 0, _vertices.length.to!int);
    }
}
