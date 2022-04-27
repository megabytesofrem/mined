module engine.renderer.vertexbuilder;

import engine.renderer.vertex;

/**
 Helper class to build a mesh from connected vertices
 */
class VertexBuilder
{
    import std.conv : to;

    private Vertex[] _vertices;

    /// Array of vertices
    public @property Vertex[] vertices()
    {
        return this._vertices;
    }

    public void push(Vertex v)
    {
        this._vertices ~= v;
    }

    public void push(Vertex[] verts)
    {
        foreach (Vertex v; verts)
        {
            this.push(v);
        }
    }

    public Vertex pop()
    {
        auto backVertex = this._vertices[$ - 1];
        this._vertices.length--;

        return backVertex;
    }
}
