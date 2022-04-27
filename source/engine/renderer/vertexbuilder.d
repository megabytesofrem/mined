module engine.renderer.vertexbuilder;

import engine.renderer.vertex;

/**
    Helper class to build a mesh from connected vertices
 */
class VertexBuilder {
    import std.conv : to;

private:
    Vertex[] _vertices;
public:
    /// Array of vertices
    @property Vertex[] vertices() {
        return this._vertices;
    }

    void push(Vertex v) {
        this._vertices ~= v;
    }

    void push(Vertex[] verts) {
        foreach (Vertex v; verts) {
            this.push(v);
        }
    }

    Vertex pop() {
        auto backVertex = this._vertices[$ - 1];
        this._vertices.length--;

        return backVertex;
    }
}
