module mined.world.chunk;

import mined.engine;
import mined.renderer.vertex;
import mined.world.blockmesh;
import mined.world.block;

struct ChunkMesh
{
    import std.stdio;

private:
    Vertex[] _vertices;

    enum _chunkWidth = 16;
    enum _chunkHeight = 32;
    enum _chunkDepth = 16;
public:
    /// VAO and VBO
    GLuint vao, vbo;

    /// Chunk data
    Block[_chunkWidth][_chunkHeight][_chunkDepth] chunkData;

    @property Vertex[] vertices()
    {
        return this._vertices;
    }

    /// Generate a chunk mesh
    void generateMesh()
    {
        writeln("Mesh is being created");
        // BlockMesh mesh;

        // Loop through the chunk dimensions, and build a mesh
        // and append that mesh to the total chunk vertices
        for (int z = 0; z < _chunkDepth; z++)
        {
            for (int y = 0; y < _chunkHeight; y++)
            {
                for (int x = 0; x < _chunkWidth; x++)
                {
                    chunkData[x][y][z] = Block(BlockType.stone);
                    auto mesh = new BlockMesh();

                    mesh.buildFace(BlockFace.front, vec3(x, y, z));
                    // mesh.buildFace(BlockFace.back, vec3(x, y, z));
                    // mesh.buildFace(BlockFace.left, vec3(x, y, z));
                    // mesh.buildFace(BlockFace.right, vec3(x, y, z));
                    // mesh.buildFace(BlockFace.top, vec3(x, y, z));
                    // mesh.buildFace(BlockFace.bottom, vec3(x, y, z));

                    //writeln("Mesh is ", mesh.vertices);

                    this._vertices ~= mesh.vertices;
                }
            }
        }
    }
}
