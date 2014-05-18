import com.codeazur.libtess2.Tesselator;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.getTimer;

function createCircle(center:Point, radius:Number, noise:Number, count:uint, clockwise:Boolean = true):Vector.<Number> {
  var vertices:Vector.<Number> = new Vector.<Number>();
  var p:Point;
  var angle:Number = 0;
  var delta:Number = 2 * Math.PI / count;
  for (var i:uint = 0; i < count; i++) {
    p = Point.polar(radius + Math.random() * noise, angle).add(center);
    vertices.push(p.x, p.y);
    angle += clockwise ? delta : -delta;
  }
  return vertices;
}

var mc:Sprite = new Sprite();
addChild(mc);

var t:Tesselator = new Tesselator();

addEventListener(Event.ENTER_FRAME, function(e:Event):void {
  var path1:Vector.<Number> = createCircle(new Point(300, 300), 250, 50, 300);
  var path2:Vector.<Number> = createCircle(new Point(300, 300), 190, 50, 200);
  var path3:Vector.<Number> = createCircle(new Point(300, 300), 130, 50, 100);
  var path4:Vector.<Number> = createCircle(new Point(300, 300), 50, 50, 50);

  t.newTess(1024 * 1024);
  t.addContour(path1, path1.length / 2, 2);
  t.addContour(path2, path2.length / 2, 2);
  t.addContour(path3, path3.length / 2, 2);
  t.addContour(path4, path4.length / 2, 2);
  t.tesselate(Tesselator.WINDING_ODD, Tesselator.ELEMENT_TYPE_POLYGONS, 3, 2);
  var vertices:Vector.<Number> = t.getVertices();
  var vertexCount:int = t.getVertexCount();
  var elements:Vector.<int> = t.getElements();
  var elementCount:int = t.getElementCount();
  t.deleteTess();

  mc.graphics.clear();
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
});
