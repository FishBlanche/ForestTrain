package Utils
{
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.toolbars.Draw;
	
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class IsoBandDraw
	{
		public function IsoBandDraw()
		{
		}
		public  function isoband(data:Array, thArray:Array,dstLayer:UIComponent):Vector.<Polygon> 
		{ 
			var i:int, j:int, k:int,x:int,y:int; 
			var count:int=0; 
			var squareWidth:Number = dstLayer.width / 10; 
			
			var squareHeight:Number = dstLayer.height / 10;
			trace("squareWidth squareHeight"+squareWidth+","+squareHeight);
			var dstPolygonVec:Vector.<Polygon> = new Vector.<Polygon>(thArray.length - 1); 
	//		trace(k);
			// 等值线的每一个阈值 
			for (k=0; k<thArray.length - 1; k++){ 
				
				// 3值化 
				var stateMat:Array=new Array;
				for (i=0; i<11; i++){ 
					stateMat[i] = new Array();
					for (j=0; j<11; j++){ 
					//	trace("data[i][j] thArray[k] thArray[k+1]"+data[i][j].z+","+thArray[k]+","+thArray[k+1]);
						if (data[i][j].z < thArray[k]){ 
							stateMat[i][j]= 0; 
						} 
						else{ 
							if (data[i][j].z < thArray[k+1]){ 
								stateMat[i][j]=1; 
							} 
							else{ 
								stateMat[i][j]= 2; 
							} 
						} 
					} 
				} 
				
				var x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number; 
				var polygon:Polygon = new Polygon; 
				
				for (y=0; y<10; y++){ 
					
					var ymin:Number =   y / 10 * dstLayer.height; 
					var ymax:Number = (y+1) / 10 * dstLayer.height; 
					
					for (x=0; x<10; x++){ 
						
						var xmin:Number =  x / 10 * dstLayer.width; 
						var xmax:Number =  (x+1) / 10 * dstLayer.width; 
						
						// square 四角坐标 
						var p7:MapPoint = new MapPoint (xmin, ymin); 
						var p9:MapPoint = new MapPoint (xmax, ymin); 
						var p3:MapPoint = new MapPoint (xmax, ymax); 
						var p1:MapPoint = new MapPoint (xmin, ymax); 
						
						// square 四角数值 
						var d7:Number = data[x][y].z; 
						var d9:Number = data[x+1][y].z; 
						var d3:Number = data[x+1][y+1].z; 
						var d1:Number = data[x][y+1].z; 
						var mid:Number; 
						
						// isoband的顶点坐标 
						var pt1:MapPoint = null; 
						var pt2:MapPoint = null; 
						var pt3:MapPoint = null; 
						var pt4:MapPoint = null; 
						var pt5:MapPoint = null; 
						var pt6:MapPoint = null; 
						var pt7:MapPoint = null; 
						var pt8:MapPoint = null; 
						
						var squareState:String = getSquareState(stateMat, x, y);
						trace("squareState  "+squareState);
						switch (squareState)        // total 81 cases 
						{ 
							// no color 
							case "2222": 
							case "0000": 
								break; 
							// square 
							case "1111": 
								polygon.addRing([p7, p9, p3, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// triangle                8 cases 
							case "2221": 
								x1 = p1.x + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								y2 = p1.y - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, p1.y); 
								pt2 = new MapPoint(p7.x, y2); 
								polygon.addRing([pt1, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2212": 
								y1 = p3.y - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								x2 = p3.x - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(p9.x, y1); 
								pt2 = new MapPoint(x2, p1.y); 
								polygon.addRing([pt1, p3, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2122": 
								x1 = p9.x - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y2 = p9.y + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								pt1 = new MapPoint(x1, p7.y); 
								pt2 = new MapPoint(p9.x, y2) 
								polygon.addRing([pt1, p9, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1222": 
								x1 = p7.x + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y2 = p7.y + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, p7.y); 
								pt2 = new MapPoint(p7.x, y2); 
								polygon.addRing([p7, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0001": 
								x1 = p3.x - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								y2 = p7.y + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, p1.y); 
								pt2 = new MapPoint(p7.x, y2); 
								polygon.addRing([pt1, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0010": 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x2, ymax); 
								polygon.addRing([pt1, p3, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0100": 
								x1 = p7.x + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y2 = p3.y - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								pt1 = new MapPoint(x1, p9.y); 
								pt2 = new MapPoint(p9.x, y2); 
								polygon.addRing([pt1, p9, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1000": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// trapezoid        8 cases 
							case "2220": 
								x1 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y1 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, p1.y); 
								pt2 = new MapPoint(x2, p1.y); 
								pt3 = new MapPoint(p7.x, y1); 
								pt4 = new MapPoint(p7.x, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2202": 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x1 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmax, y2); 
								pt3 = new MapPoint(x1, ymax); 
								pt4 = new MapPoint(x2, ymax); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2022": 
								x1 = p9.x - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = p9.x - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = p9.y + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = p9.y + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								pt1 = new MapPoint(x1, p9.y); 
								pt2 = new MapPoint(x2, p9.y); 
								pt3 = new MapPoint(p9.x ,y1); 
								pt4 = new MapPoint(p9.x, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0222": 
								x1 = p7.x + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = p7.x + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = p7.y + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y2 = p7.y + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, p7.y); 
								pt2 = new MapPoint(x2, p7.y); 
								pt3 = new MapPoint(p7.x, y1); 
								pt4 = new MapPoint(p7.x, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0002": 
								x1 = p3.x - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x2 = p3.x - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y1 = p7.y + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y2 = p7.y + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, p1.y); 
								pt2 = new MapPoint(x2, p1.y); 
								pt3 = new MapPoint(p1.x, y1); 
								pt4 = new MapPoint(p1.x, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0020": 
								y1 = p9.y + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = p9.y + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x1 = p1.x + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x2 = p1.x + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(p3.x, y1); 
								pt2 = new MapPoint(p3.x, y2); 
								pt3 = new MapPoint(x1, p3.y); 
								pt4 = new MapPoint(x2, p3.y); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0200": 
								x1 = p7.x + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = p7.x + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = p3.y - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = p3.y - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								pt1 = new MapPoint(x1, p9.y); 
								pt2 = new MapPoint(x2, p9.y); 
								pt3 = new MapPoint(p9.x, y1); 
								pt4 = new MapPoint(p9.x, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2000": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmin, y1); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// rectangle 12 cases 
							case "0011": 
								y1 = p9.y + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = p7.y + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(p9.x, y1); 
								pt2 = new MapPoint(p7.x, y2); 
								polygon.addRing([pt1, p3, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0110": 
								x1 = p7.x + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = p1.x + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, p7.y); 
								pt2 = new MapPoint(x2, p1.y); 
								polygon.addRing([pt1, p9, p3, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1100": 
								y1 = p3.y - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								y2 = p1.y - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(p9.x, y1); 
								pt2 = new MapPoint(p7.x, y2); 
								polygon.addRing([p7, p9, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1001": 
								x1 = p9.x - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								x2 = p3.x - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, p7.y); 
								pt2 = new MapPoint(x2, p1.y); 
								polygon.addRing([p7, pt1, pt2, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2211": 
								y1 = p3.y - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = p1.y - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p3, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2112": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								polygon.addRing([pt1, p9, p3, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1122": 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareWidth; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, p9, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1221": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								polygon.addRing([p7, pt1, pt2, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2200": 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								y3 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y4 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmax, y2); 
								pt3 = new MapPoint(xmin, y3); 
								pt4 = new MapPoint(xmin, y4); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2002": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								x3 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x4 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(x4, ymax); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0022": 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								y3 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y4 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmax, y2); 
								pt3 = new MapPoint(xmin, y3); 
								pt4 = new MapPoint(xmin, y4); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0220": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								x3 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x4 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(x4, ymax); 
								polygon.addRing([pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// hexagon 12 cases 
							case "0211": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, pt2, pt3, p3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2110": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y1 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								pt3 = new MapPoint(xmin, y1); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, p3, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1102": 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x1 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x1, ymax); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, p9, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1021": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(x2, ymax); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2011": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, pt2, pt3, p3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0112": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y2 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								pt3 = new MapPoint(xmin, y1); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, p3, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1120": 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x1 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x1, ymax); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, p9, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1201": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax -  (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(x2, ymax); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2101": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymax -  (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0121": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymin + (thArray[k] - d7)        / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1012": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, pt1, pt2, p3, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1210": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, pt1, pt2, p3, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// pentagon        24 cases 
							case "1211": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y2 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y2); 
								polygon.addRing([p7, pt1, pt2, p3, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2111": 
								x1 = xmax -  (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, p3, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1112": 
								x1 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymax); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, p9, p3, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1121": 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x2, ymax); 
								polygon.addRing([p7, p9, pt1, pt2, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1011": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y2 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y2); 
								polygon.addRing([p7, pt1, pt2, p3, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0111": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y2 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([pt1, p9, p3, p1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1110": 
								x1 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymax); 
								pt2 = new MapPoint(xmin, y2); 
								polygon.addRing([p7, p9, p3, pt1, pt2]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1101": 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x2, ymax); 
								polygon.addRing([p7, p9, pt1, pt2, p1]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1200": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								y3 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0120": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(x3, ymax); 
								polygon.addRing([pt1, p9, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0012": 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								x1 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x1, ymax); 
								pt3 = new MapPoint(xmin, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, p3, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2001": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								x3 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								y1 = ymax -  (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(xmin, y1); 
								polygon.addRing([pt1, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1022": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								y3 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2102": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(x3, ymax); 
								polygon.addRing([pt1, p9, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2210": 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								x1 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(x1, ymax); 
								pt3 = new MapPoint(xmin, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, p3, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0221": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								x3 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								y1 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(xmin, y1); 
								polygon.addRing([pt1, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1002": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(xmin, y1); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2100": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmin, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, p9, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0210": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(x3, ymax); 
								polygon.addRing([pt1, pt2, pt3, p3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0021": 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x1 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmax, y2); 
								pt3 = new MapPoint(x1, ymax); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1220": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y1 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymax); 
								pt3 = new MapPoint(x3, ymax); 
								pt4 = new MapPoint(xmin, y1); 
								polygon.addRing([p7, pt1, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0122": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmin, y2); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, p9, pt2, pt3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2012": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(x3, ymax); 
								polygon.addRing([pt1, pt2, pt3, p3, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2201": 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x1 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(xmax, y1); 
								pt2 = new MapPoint(xmax, y2); 
								pt3 = new MapPoint(x1, ymax); 
								pt4 = new MapPoint(xmin, y3); 
								polygon.addRing([pt1, pt2, pt3, p1, pt4]); 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// saddles - 8 sided        2 cases 
							case "2020": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x3 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x4 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y3 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y4 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmax, y2); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(x4, ymax); 
								pt7 = new MapPoint(xmin, y3); 
								pt8 = new MapPoint(xmin, y4); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([pt1, pt2, pt7, pt8]); 
									polygon.addRing([pt3, pt4, pt5, pt6]); 
								} 
								else if (mid < thArray[k+1]){ 
									polygon.addRing([pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt3, pt4]); 
									polygon.addRing([pt5, pt6, pt7, pt8]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0202": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x3 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x4 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y3 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y4 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmax, y2); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(x4, ymax); 
								pt7 = new MapPoint(xmin, y3); 
								pt8 = new MapPoint(xmin, y4); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([pt1, pt2, pt3, pt4]); 
									polygon.addRing([pt5, pt6, pt7, pt8]); 
								} 
								else if (mid < thArray[k+1]){ 
									polygon.addRing([pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt7, pt8]); 
									polygon.addRing([pt3, pt4, pt5, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// saddles:        6 sided                4 cases 
							case "0101": 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									x1 = p7.x + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
									y2 = p3.y - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
									pt1 = new MapPoint(x1, p9.y); 
									pt2 = new MapPoint(p9.x, y2); 
									polygon.addRing([pt1, p9, pt2]); 
									
									x1 = p3.x - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
									y2 = p7.y + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
									pt1 = new MapPoint(x1, p1.y); 
									pt2 = new MapPoint(p7.x, y2); 
									polygon.addRing([pt1, p1, pt2]); 
								} 
								else{ 
									x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
									y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
									x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
									y2 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
									pt1 = new MapPoint(x1, ymin); 
									pt2 = new MapPoint(xmax, y1); 
									pt3 = new MapPoint(x2, ymax); 
									pt4 = new MapPoint(xmin, y2); 
									polygon.addRing([pt1, p9, pt2, pt3, p1, pt4]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1010": 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
									y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
									pt1 = new MapPoint(x1, ymin); 
									pt2 = new MapPoint(xmin, y2); 
									polygon.addRing([p7, pt1, pt2]); 
									
									y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
									x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
									pt1 = new MapPoint(p9.x, y1); 
									pt2 = new MapPoint(x2, p1.y); 
									polygon.addRing([pt1, p3, pt2]); 
								} 
								else{ 
									x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
									y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
									x2 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
									y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
									pt1 = new MapPoint(x1, ymin); 
									pt2 = new MapPoint(xmax, y1); 
									pt3 = new MapPoint(x2, ymax); 
									pt4 = new MapPoint(xmin, y2); 
									polygon.addRing([p7, pt1, pt2, p3, pt3, pt4]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2121": 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
									y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
									x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
									y2 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
									pt1 = new MapPoint(x1, ymin); 
									pt2 = new MapPoint(xmax, y1); 
									pt3 = new MapPoint(x2, ymax); 
									pt4 = new MapPoint(xmin, y2); 
									polygon.addRing([pt1, p9, pt2, pt3, p1, pt4]); 
								} 
								else{ 
									x1 = p9.x - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
									y2 = p9.y + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
									pt1 = new MapPoint(x1, p7.y); 
									pt2 = new MapPoint(p9.x, y2) 
									polygon.addRing([pt1, p9, pt2]); 
									
									x1 = p1.x + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
									y2 = p1.y - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
									pt1 = new MapPoint(x1, p1.y); 
									pt2 = new MapPoint(p7.x, y2); 
									polygon.addRing([pt1, p1, pt2]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1212": 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
									y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
									x2 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
									y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
									pt1 = new MapPoint(x1, ymin); 
									pt2 = new MapPoint(xmax, y1); 
									pt3 = new MapPoint(x2, ymax); 
									pt4 = new MapPoint(xmin, y2); 
									polygon.addRing([p7, pt1, pt2, p3, pt3, pt4]); 
								} 
								else{ 
									x1 = p7.x + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
									y2 = p7.y + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
									pt1 = new MapPoint(x1, p7.y); 
									pt2 = new MapPoint(p7.x, y2); 
									polygon.addRing([p7, pt1, pt2]); 
									y1 = p3.y - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
									x2 = p3.x - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
									pt1 = new MapPoint(p9.x, y1); 
									pt2 = new MapPoint(x2, p1.y); 
									polygon.addRing([pt1, p3, pt2]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							// saddles 7 sided                8 cases 
							case "2120": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(x3, ymax); 
								pt5 = new MapPoint(xmin, y2); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									polygon.addRing([pt1, p9, pt2, pt3, pt4, pt5, pt6]); 
								} 
								else{ 
									polygon.addRing([pt1, p9, pt2]); 
									polygon.addRing([pt3, pt4, pt5, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2021": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x3 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmax, y2); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									polygon.addRing([pt1, pt2, pt3, pt4, pt5, p1, pt6]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt3, pt4]); 
									polygon.addRing([pt5, p1, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1202": 
								x1 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y3 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(x2, ymax); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(xmin, y3); 
								
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									polygon.addRing([p7, pt1, pt2, pt3, pt4, pt5, pt6]); 
								} 
								else{ 
									polygon.addRing([p7, pt1, pt6]); 
									polygon.addRing([pt2, pt3, pt4, pt5]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0212": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(x3, ymax); 
								pt5 = new MapPoint(xmin, y2); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k+1]){ 
									polygon.addRing([pt1, pt2, pt3, p3, pt4, pt5, pt6]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt5, pt6]); 
									polygon.addRing([pt3, p3, pt4]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0102": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x2 = xmax - (thArray[k] - d3) / (d1 - d3) * squareWidth; 
								x3 = xmax - (thArray[k+1] - d3) / (d1 - d3) * squareWidth; 
								y2 = ymin + (thArray[k+1] - d7) / (d1 - d7) * squareHeight; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(x2, ymax); 
								pt4 = new MapPoint(x3, ymax); 
								pt5 = new MapPoint(xmin, y2); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([pt1, p9, pt2]); 
									polygon.addRing([pt3, pt4, pt5, pt6]); 
								} 
								else{ 
									polygon.addRing([pt1, p9, pt2, pt3, pt4, pt5, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "0201": 
								x1 = xmin + (thArray[k] - d7) / (d9 - d7) * squareWidth; 
								x2 = xmin + (thArray[k+1] - d7) / (d9 - d7) * squareWidth; 
								y1 = ymax - (thArray[k+1] - d3) / (d9 - d3) * squareHeight; 
								y2 = ymax - (thArray[k] - d3) / (d9 - d3) * squareHeight; 
								x3 = xmax - (thArray[k] - d3) / (d1- d3) * squareWidth; 
								y3 = ymin + (thArray[k] - d7) / (d1 - d7) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(xmax, y2); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([pt1, pt2, pt3, pt4]); 
									polygon.addRing([pt5, p1, pt6]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt3, pt4, pt5, p1, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "1020": 
								x1 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								y2 = ymin + (thArray[k+1] - d9) / (d3 - d9) * squareHeight; 
								x2 = xmin + (thArray[k+1] - d1) / (d3 - d1) * squareWidth; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y3 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(xmax, y1); 
								pt3 = new MapPoint(xmax, y2); 
								pt4 = new MapPoint(x2, ymax); 
								pt5 = new MapPoint(x3, ymax); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([p7, pt1, pt6]); 
									polygon.addRing([pt2, pt3, pt4, pt5,]); 
								} 
								else{ 
									polygon.addRing([p7, pt1, pt2, pt3, pt4, pt5, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							case "2010": 
								x1 = xmax - (thArray[k+1] - d9) / (d7 - d9) * squareWidth; 
								x2 = xmax - (thArray[k] - d9) / (d7 - d9) * squareWidth; 
								y1 = ymin + (thArray[k] - d9) / (d3 - d9) * squareHeight; 
								x3 = xmin + (thArray[k] - d1) / (d3 - d1) * squareWidth; 
								y2 = ymax - (thArray[k] - d1) / (d7 - d1) * squareHeight; 
								y3 = ymax - (thArray[k+1] - d1) / (d7 - d1) * squareHeight; 
								pt1 = new MapPoint(x1, ymin); 
								pt2 = new MapPoint(x2, ymin); 
								pt3 = new MapPoint(xmax, y1); 
								pt4 = new MapPoint(x3, ymax); 
								pt5 = new MapPoint(xmin, y2); 
								pt6 = new MapPoint(xmin, y3); 
								mid = (d7 + d9 + d3 + d1) / 4; 
								if (mid < thArray[k]){ 
									polygon.addRing([pt1, pt2, pt5, pt6]); 
									polygon.addRing([pt3, p3, pt4]); 
								} 
								else{ 
									polygon.addRing([pt1, pt2, pt3, p3, pt4, pt5, pt6]); 
								} 
								trace("polygon.addRing  k"+k+","+squareState);
								break; 
							default: 
								break; 
						} 
					} 
				} 
				dstPolygonVec[k] = polygon; 
				
			    
				//dstLayer.addChild(polygon);
				//DrawToolBox.qyPolygon(dstLayer, polygon, 0, 0, 0.8, colorArray[k]); 
			} 
			return dstPolygonVec; 
			
		}
	public 	function getSquareState(mat:Array, x:int, y:int):String 
		{ 
			var str:String = ''; 
			str += String(mat[x][y]); 
			str += String(mat[x + 1][y]); 
			str += String(mat[x + 1][y + 1]); 
			str += String(mat[x][y + 1]); 
			return str; 
		} 
		
	}
}