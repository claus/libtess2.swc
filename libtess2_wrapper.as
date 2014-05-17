package com.codeazur.libtess2
{
  import com.codeazur.libtess2.lib.*;

  public class Tesselator
  {
    public static const WINDING_ODD:int = 0;
    public static const WINDING_NONZERO:int = 1;
    public static const WINDING_POSITIVE:int = 2;
    public static const WINDING_NEGATIVE:int = 3;
    public static const WINDING_ABS_GEQ_TWO:int = 4;

    public static const ELEMENT_TYPE_POLYGONS:int = 0;
    public static const ELEMENT_TYPE_CONNECTED_POLYGONS:int = 1;
    public static const ELEMENT_TYPE_BOUNDARY_CONTOURS:int = 2;

    private var t:int = 0;

    public function Tesselator() {
      CModule.startAsync(this);
    }

    public function newTess(memorySize:int):void {
      if (t !== 0) { deleteTess(); }
      t = libtess2.newTess(1024 * 1024);
    }

    public function deleteTess():void {
      libtess2.deleteTess(t);
    }

    public function addContour(vertices:Vector.<Number>, count:uint, vertexSize:uint = 2):void {
      var vertexCount:int = vertices.length;
      var vertexPtr:int = CModule.malloc(4 * vertexCount);
      for (var i:int = 0, p:int = vertexPtr; i < vertexCount; i++) {
        CModule.writeFloat(p, vertices[i]);
        p += 4;
      }
      libtess2.addContour(t, vertexSize, vertexPtr, 4 * vertexSize, count);
      CModule.free(vertexPtr);
    }

    public function tesselate(windingRule:int, elementType:int, polySize:int = 3, vertexSize:int = 2):int {
      return libtess2.tesselate(t, windingRule, elementType, polySize, vertexSize);
    }

    public function getVertexCount():int {
      return libtess2.getVertexCount(t);
    }

    public function getVertices():Vector.<Number> {
      var vertexCount:int = getVertexCount() * 2;
      var vertexPtr:int = libtess2.getVertices(t);
      var vertices:Vector.<Number> = new Vector.<Number>(vertexCount);
      for (var i:int = 0, p:int = vertexPtr; i < vertexCount; i++) {
        vertices[i] = CModule.readFloat(p);
        p += 4;
      }
      return vertices;
    }

    public function getVertexIndices():Vector.<int> {
      var elementCount:int = getElementCount() * 3;
      var elementPtr:int = libtess2.getElements(t);
      return CModule.readIntVector(elementPtr, elementCount);
    }

    public function getElementCount():int {
      return libtess2.getElementCount(t);
    }

    public function getElements():Vector.<int> {
      var elementCount:int = getElementCount() * 3;
      var elementPtr:int = libtess2.getElements(t);
      return CModule.readIntVector(elementPtr, elementCount);
    }
  }
}
