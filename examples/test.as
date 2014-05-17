import flash.display.Sprite;
import com.codeazur.libtess2.Tesselator;

var path1:Vector.<Number> = Vector.<Number>([0,0, 200,0, 200,200, 0,200]);
var path2:Vector.<Number> = Vector.<Number>([50,50, 150,50, 150,150, 50,150]);

var t:Tesselator = new Tesselator();
t.newTess(1024 * 1024);
t.addContour(path1, path1.length / 2, 2);
t.addContour(path2, path2.length / 2, 2);
t.tesselate(Tesselator.WINDING_ODD, Tesselator.ELEMENT_TYPE_POLYGONS, 3, 2);
var vertices:Vector.<Number> = t.getVertices();
var vertexCount:int = t.getVertexCount();
var elements:Vector.<int> = t.getElements();
var elementCount:int = t.getElementCount();
t.deleteTess();

var mc:Sprite = new Sprite();
mc.x = 20;
mc.y = 20;
addChild(mc);

mc.graphics.lineStyle(1, 0x008800);
for (var i:int; i < elementCount; i++) {
  var v1x:Number = vertices[elements[i * 3] * 2];
  var v1y:Number = vertices[elements[i * 3] * 2 + 1];
  var v2x:Number = vertices[elements[i * 3 + 1] * 2];
  var v2y:Number = vertices[elements[i * 3 + 1] * 2 + 1];
  var v3x:Number = vertices[elements[i * 3 + 2] * 2];
  var v3y:Number = vertices[elements[i * 3 + 2] * 2 + 1];
  mc.graphics.beginFill(0x00cc00, 0.5);
  mc.graphics.moveTo(v1x, v1y);
  mc.graphics.lineTo(v2x, v2y);
  mc.graphics.lineTo(v3x, v3y);
  mc.graphics.endFill();
}
