module mined.renderer.chunkrenderer;

import mined.engine;
import mined.engine.renderer;
import mined.renderer.vertex;
import mined.world.blockmesh;

import std.stdio;
import std.conv : to;

class ChunkRenderer : Renderer
{
    import mined.world.block : Block, BlockType;
    import mined.world.chunk;

private:
    ShaderProgram _program;
    ChunkMesh _chunkMesh;
public:
    mat4 modelMatrix;
    GLuint vao;

    @property ref ChunkMesh chunkMesh()
    {
        return this._chunkMesh;
    }

    this()
    {
        this.modelMatrix = mat4.identity;
        this.initRenderer();
    }

    override void initRenderer()
    {
        writeln("initRenderer called");
        _chunkMesh = ChunkMesh();

        // Generate the VAO
        glGenVertexArrays(1, &chunkMesh.vao);
        glBindVertexArray(chunkMesh.vao);

        chunkMesh.generateMesh();

        // Bind the VBO
        glGenBuffers(1, &chunkMesh.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, chunkMesh.vbo);

        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * chunkMesh.vertices.length, chunkMesh.vertices.ptr, GL_STATIC_DRAW);

        // 3 floats for X Y Z
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, null);
        glEnableVertexAttribArray(0);

        // Texture coords
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, null);
        glEnableVertexAttribArray(1);
    }

    override void render(ShaderProgram program)
    {
        glBindVertexArray(chunkMesh.vao);
        program.use;

        glDrawArrays(GL_TRIANGLES, 0, chunkMesh.vertices.length.to!int);
    }
}
