package components
{
	import mx.core.UIComponent;
	import flash.geom.Point;
	public class RoutingPath extends UIComponent {

		
		public function RoutingPath(pathNodePosition:Vector.<Point>){
			var dashlen:Number=Number(10*Math.random());
			//dashgap:Number=Number(10*Math.random());

			for(var i:int =0 ;i < pathNodePosition.length-1; i++){							
				drawDashLine(pathNodePosition[i].x,pathNodePosition[i].y,
					pathNodePosition[i+1].x,pathNodePosition[i+1].y,dashlen,8);
			//	drawLine(pathNodePosition[i].x,pathNodePosition[i].y,
			//		pathNodePosition[i+1].x,pathNodePosition[i+1].y);
			}
		}
		
		/*draw dash line between two points under the control of the  dashlen and dashgap parameters
		input:startPoint,endPoint，dashlength,dashgap
		output:
		*/
		private function drawDashLine( x1:Number, y1:Number,x2:Number, y2:Number,dashlen:Number,dashgap:Number):void
		{
			graphics.lineStyle(3,0xddff94,0.8);
			var x:Number = x2 - x1;
			var y:Number = y2 - y1;
			var hyp:Number = Math.sqrt((x)*(x) + (y)*(y));
			
			var units:Number = hyp/(dashlen+dashgap);
			var dashSpaceRatio:Number = dashlen/(dashlen+dashgap);
			
			var dashX:Number = (x/units)*dashSpaceRatio;
			var spaceX:Number = (x/units)-dashX;
			var dashY:Number = (y/units)*dashSpaceRatio;
			var spaceY:Number = (y/units)-dashY;			
			graphics.moveTo(x1, y1);			
			while (hyp > 0)
			{
				x1 += dashX;
				y1 += dashY;
				hyp -= dashlen;
				if (hyp < 0)
				{
					x1 = x2;
					y1 = y2;
				}				
				graphics.lineTo(x1, y1);
				x1 += spaceX;
				y1 += spaceY;
				graphics.moveTo(x1, y1);
				hyp -= dashgap;
			}			
			graphics.moveTo(x2, y2);
		}
		private function drawLine(x1:Number, y1:Number,x2:Number, y2:Number):void{
			graphics.lineStyle(2,0x009fff,0.8);
			graphics.moveTo(x1, y1);
			graphics.lineTo(x2, y2);
		}
	}
}