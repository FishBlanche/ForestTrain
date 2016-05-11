/****
	*
	* Isolining package for AS3
	*
	* @author Zachary Forest Johnson (indiemaps.com/blog or zach.f.johnson@gmail.com)
	* @date June 2008
	* 
	* requires my delaunay package (available here: http://indiemaps.com/code/delaunay.zip)
	*
	* uh oh, now also requires Andy Woodruff's cubicBezier class (available here: http://cartogrammar.com/source/CubicBezier.as)
	*
	* all required packages / classes should be found wherever you found this file
	*
	* an indiemaps production, infinitely muggable division
	*
	* use as you will!
	*
****/

package com.indiemaps.isolines {
	import com.cartogrammar.drawing.CubicBezier;
	import com.indiemaps.delaunay.IEdge;
	import com.indiemaps.delaunay.XYZ;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.controls.Image;
	import mx.controls.ToolTip;
	import mx.formatters.NumberFormatter;
	import mx.managers.ToolTipManager;
	
	import spark.components.Group;
	
	import model.MyLine;
	import model.MyPoint;

	
	public class MyIsoUtils{
		
		public static	var closedLine:Array=[];
		public function MyIsoUtils() {
			// constructor function has no code
			// class is a container for static methods
		}
		
		/*
		public static method isoline
		
		calls other methods on inputted triangular mesh
		returns an array of isolines
		*/
		public static function isosFurtherHandle(lines:Array,outsidePoints:Array,tris:Array,pointArr:Array,clip:Group):Array
		{
			var closedlineLen:int=closedLine.length;
			var beginIndex:int;
			for(beginIndex=0;beginIndex<closedlineLen;beginIndex++)
			{
				closedLine.pop();
			}
			
			
			var edges:Array = MyIsoUtils.getEdges(tris);
			var edgesOutSide:Array =[];
			for (var edgenum in edges) {
				var edge:IEdge = edges[edgenum];						
				if(edge.numTris==1)
				{
					edgesOutSide.push(edge);
					//trace("edge   "+edge.p1+","+edge.p2);
				}
			}
		//	trace("edgesOutSide"+edgesOutSide.length);
			var linesLen:int=lines.length;
			var otPtLen:int=outsidePoints.length;
            var otEdgeLen:int=edgesOutSide.length;
			var i:int;
			var j:int;
			var k:int;
			var nextPtOne:int=-1;
			var nextPtOther:int=-1;
			//var flag:int=1;
			var ptMinToStart:int=0;
			var ptMinToStart2:int=0;
			var ptMinToEnd:int=0;
			var coordsLength:int=0;
			var minDistToStart:Number=0;
			var minDistToEnd:Number=0;
			
			var newLines:Array=[];
			for(i=0;i<linesLen;i++)
			{
				coordsLength=lines[i].coords.length;
				if(Point.distance(lines[i].coords[0],lines[i].coords[coordsLength-1])<12||coordsLength==1)
				{
					 if(coordsLength!=1)
					 {
						 closedLine.push(lines[i]);
					//	 trace("coordsLength  int(Math.ceil(coordsLength/2)"+coordsLength+","+(int(Math.ceil(coordsLength/2))));
						 lines[i].coordsLen=Point.distance(lines[i].coords[0],lines[i].coords[int(Math.ceil(coordsLength/2))]);
				//		 trace("lines[i].coordsLen"+lines[i].coordsLen+","+coordsLength);
					 }
					continue;
				}
				if(coordsLength>1&&otPtLen>0)
				{
					 
				
					minDistToStart=Point.distance(new Point(lines[i].coords[0].x,lines[i].coords[0].y),new Point(pointArr[outsidePoints[0]].x,pointArr[outsidePoints[0]].y));
					minDistToEnd=Point.distance(new Point(lines[i].coords[coordsLength-1].x,lines[i].coords[coordsLength-1].y),new Point(pointArr[outsidePoints[0]].x,pointArr[outsidePoints[0]].y));
					
					ptMinToStart =outsidePoints[0];
					ptMinToStart2 =outsidePoints[0];
					ptMinToEnd =outsidePoints[0];
					//trace("outsidePoints[0]"+outsidePoints[0]);
					for(j=1;j<otPtLen;j++)
					{
						//trace("otPtLen  j outsidePoints[j]"+otPtLen+","+j+","+outsidePoints[j]);
						var a:Number=Point.distance(new Point(lines[i].coords[0].x,lines[i].coords[0].y),new Point(pointArr[outsidePoints[j]].x,pointArr[outsidePoints[j]].y));
						var b:Number=Point.distance(new Point(lines[i].coords[coordsLength-1].x,lines[i].coords[coordsLength-1].y),new Point(pointArr[outsidePoints[j]].x,pointArr[outsidePoints[j]].y));
						if(a<minDistToStart)
						{
							minDistToStart=a;
							ptMinToStart=outsidePoints[j];
							ptMinToStart2=outsidePoints[j];
						}
						if(b<minDistToEnd)
						{
							minDistToEnd=b;
							ptMinToEnd=outsidePoints[j];
						}
					}
				}
				var flag=1;
				 var count1:int=0;
				 var tempArray1:Array=[];
				 var count2:int=0;
				 var tempArray2:Array=[];
				 var pre1:int=ptMinToStart;
				 var pre2:int=ptMinToStart;
				  nextPtOne=-1;
				  nextPtOther=-1;
				//   trace("ptMinToStart  ptMinToEnd"+ptMinToStart+","+ptMinToEnd);
				  if(ptMinToStart!=ptMinToEnd)
				  {
					  for(k=0;k<otEdgeLen;k++)
					  {
						  if(edgesOutSide[k].p1==ptMinToStart)
						  {
							  if(flag==1)
							  {
								  nextPtOne=edgesOutSide[k].p2;
								  flag=2;
							  }
							  else 
							  {
								  nextPtOther=edgesOutSide[k].p2;
								  k=otEdgeLen;
							  }
						  }
						  else if(edgesOutSide[k].p2==ptMinToStart)
						  {
							  
							  if(flag==1)
							  {
								  nextPtOne=edgesOutSide[k].p1;
								  flag=2;
							  }
							  else 
							  {
								  nextPtOther=edgesOutSide[k].p1;
								  k=otEdgeLen;
							  }
						  }
					  }
		//		 	  trace("nextPtOne  nextPtOther "+nextPtOne+",,,"+nextPtOther);
					 
					  
					   
						  for(k=0;(nextPtOne!=ptMinToEnd);k++)
						  {
							  
							  
							  //		  trace("nextPtOne    "+nextPtOne+","+edgesOutSide[k%otEdgeLen].p1+","+edgesOutSide[k%otEdgeLen].p2);
							  if(edgesOutSide[k%otEdgeLen].p1==nextPtOne&&edgesOutSide[k%otEdgeLen].p2!=pre1)
							  {
						//		  trace("nextPtOne---"+nextPtOne);
								  tempArray1.push(pointArr[nextPtOne]);
								  pre1=nextPtOne;
								  nextPtOne=edgesOutSide[k%otEdgeLen].p2;
								  count1++;
							  }
							  else if(edgesOutSide[k%otEdgeLen].p2==nextPtOne&&edgesOutSide[k%otEdgeLen].p1!=pre1)
							  {
							//	  trace("nextPtOne---"+nextPtOne);
								  tempArray1.push(pointArr[nextPtOne]);
								  pre1=nextPtOne;
								  nextPtOne=edgesOutSide[k%otEdgeLen].p1;
								  count1++;
							  }
						  }
					  
					
					//  trace("count1"+count1);
					 
						  for(k=0;(nextPtOther!=ptMinToEnd);k++)
						  {
							  // trace("k%otEdgeLen nextPtOne"+(k%otEdgeLen)+","+nextPtOther);
							  
							  if(edgesOutSide[k%otEdgeLen].p1==nextPtOther&&edgesOutSide[k%otEdgeLen].p2!=pre2)
							  {
								 // trace("nextPtOther---"+nextPtOther);
								  tempArray2.push(pointArr[nextPtOther]);
								  pre2= nextPtOther;
								  nextPtOther=edgesOutSide[k%otEdgeLen].p2;
								  count2++;
							  }
							  else if(edgesOutSide[k%otEdgeLen].p2==nextPtOther&&edgesOutSide[k%otEdgeLen].p1!=pre2)
							  {
								//  trace("nextPtOther---"+nextPtOther);
								  tempArray2.push(pointArr[nextPtOther]);
								  pre2= nextPtOther;
								  nextPtOther=edgesOutSide[k%otEdgeLen].p1;
								  count2++;
							  }
						  }
					 
					 
					//  trace("count2"+count2);
					  lines[i].coordsLen=count1>count2?count2:count1;
					  if(count1<count2)
					  {
						//  trace("count1<count2"+count1);
						  var s:int;
						  for(s=0;s<count1;s++)
						  {
							
							  lines[i].coords.unshift(tempArray1[s]);
						  }
						
						  lines[i].coords.unshift(pointArr[ptMinToEnd]);
					  }
					  else
					  {
						 // trace("count1>count2"+count2);
						  var s:int;
						  for(s=0;s<count2;s++)
						  {
							 
							  lines[i].coords.unshift(tempArray2[s]);
						  }
						
						  lines[i].coords.unshift(pointArr[ptMinToEnd]);
					  }
				  }
				  else
				  {
					 
					  lines[i].coordsLen=1;
					  lines[i].coords.unshift(pointArr[ptMinToEnd]);
				  }
				  newLines.push(lines[i]);
			}
			 
			return newLines;
		}
		public static function getOutSidePoints(tris:Array,points:Array):Array{
			var edges:Array = MyIsoUtils.getEdges(tris);
			var outsidePointsArray:Array=new Array;
			var i:int;
			var pt1Init:Boolean=false;
			var pt2Init:Boolean=false;
			for (var edgenum in edges) {
				var edge:IEdge = edges[edgenum];						
				if(edge.numTris==1)
				{
					var a=points[edge.p1].x;
					var lentemp:int=outsidePointsArray.length;
					if(lentemp>0)
					{
						 
						for(i=0;i<lentemp;i++)
						{
							if(points[outsidePointsArray[i]].x==points[edge.p1].x&&points[outsidePointsArray[i]].y==points[edge.p1].y)
							{
								pt1Init=true;
							}
							if(points[outsidePointsArray[i]].x==points[edge.p2].x&&points[outsidePointsArray[i]].y==points[edge.p2].y)
							{
								pt2Init=true;
							} 
						}
					}
					
					if(!pt1Init)
					{
						outsidePointsArray.push(edge.p1);
					}
					if(!pt2Init)
					{
						outsidePointsArray.push(edge.p2);
					}
					pt1Init=false;
					pt2Init=false;
					
				}
			}
			return outsidePointsArray;
		}
		public static function isoline(tris:Array, points:Array, clip:Group, interval:Number, origin:Number=0):Array {
			//first, get a nonredundant array of all the edges
			var edges:Array = MyIsoUtils.getEdges(tris);
			
			//store the point not include the inside ones
			 
			
			
			 
			/* 	then, interpolate values along each edge according to the chosen interval and origin
				this will attach the interpolated points directly to the edge objects themselves
			*/
			findInterVals(clip,edges, points, interval, origin);
			
			//then, string the actual isolines
			var isos:Array = stringIsolines(edges, tris, points); //returns an array of isolines
			
			//return the array of isolines
			return isos;
			
		}
		
		/*
		public static method getEdges
		
		returns a nonredundant array of all edges in a triangulation
		takes as input a triangular mesh (an array of triangles created by triangulate method)
		*** HOPEFULLY this method won't be necessary soon
		*** NEED to find some way of generating this more efficiently directly from the Delaunay.triangulate method
		*** CURRENTLY this takes WAY longer than the triangulation itself
		*** THIS is the bottleneck in isolining
		*/
		public static function getEdges(v:Array):Array {
			var allEdges = new Array(); //array to hold all edges nonredundantly
			for (var trinum in v) { //loop through each triangle
				var tri = v[trinum];
				v[trinum].eArray = new Array();
				
				var eArray:Array = new Array();
				eArray.push(new IEdge(tri.p1, tri.p2));
				eArray.push(new IEdge(tri.p2, tri.p3));
				eArray.push(new IEdge(tri.p3, tri.p1));
			//	trace("getEdges    "+tri.p1+","+tri.p2+","+tri.p3);
				for (var enum in eArray) {
					var e = eArray[enum];
					var inIt = false;
					
					for (var edgenum in allEdges) {
						var edge = allEdges[edgenum];						
						if ((edge.p1 == e.p1 && edge.p2 == e.p2) || (edge.p1 == e.p2 && edge.p2 == e.p1)) { 
							v[trinum].eArray.push(edgenum);
							allEdges[edgenum].numTris += 1;
							allEdges[edgenum].tris.push(trinum);
							inIt = true;
							break;
						}
					}
					
					if (!inIt) {
						v[trinum].eArray.push(allEdges.length);
						allEdges.push(e);
						allEdges[allEdges.length-1].numTris += 1;
						allEdges[allEdges.length-1].tris = new Array();
						allEdges[allEdges.length-1].tris.push(trinum);
					}
				}
				
			}
			return allEdges;
		}
		
		/*
		static method findInterVals
		
		interpolates critical points along all edges that fall on the interval specified
		the number inputted is the interval, ex: .01, .1, 1, 10, 100, 7
		takes an array of IEdges
		also requires the original array of points
		b/c the array of ITriangles simply references key positions in the points array
		***should also allow for an origin (like 5 degree contour interval, but starting at 32 degrees or something, rather than zero)
		*/
		static function findInterVals(clip:Group,edges:Array, points:Array, interval:Number, origin:Number=0):void {
			 
			for (var enum in edges) { //for each edge in the array
				//call the method to interpolate values along an edge
				MyIsoUtils.pointsOnEdge(clip,edges[enum], points, interval, origin);
			}
			//and don't return a goddamned thing
		}
		
		/*
		private static method pointsOnEdge
		
		returns an array of the coordinates and value (an XYZ object) of any found interval values
		uses strict linear interpolation
		*/
		private static function pointsOnEdge(clip:Group,edge:IEdge, points:Array, interval:Number, origin:Number=0):void {
			var p1 = points[edge.p1]; // p1 of this edge
			var p2 = points[edge.p2]; // p2 of this edge
			
			// first, determine which has the greater 'x' of p1 and p2 (b/c this changes how we calculate slope)
			if (p2.x > p1.x) {
				var startPt = p1;
				var currVal = p1.z;
				var slope = ((p2.y - p1.y) / (p2.x - p1.x));
			} else {
				var startPt = p2;
				var currVal = p2.z;
				var slope = ((p1.y - p2.y) / (p1.x - p2.x));
			}
			if (slope > 0) { 
				var angle = Math.asin(slope/(Math.sqrt(slope*slope + 1))); // the angle of A
				var ymulti = -1;
			} else {
				var angle = (2 * Math.PI) - Math.asin(slope/(Math.sqrt(slope*slope + 1))); // the angle of A
				var ymulti = 1;
			}
			var dist; // will hold how far away from either p1 or p2 the next interpolated point is
			var currPt = new XYZ();
			var lineLength = Point.distance(new Point(p1.x, p1.y), new Point(p2.x, p2.y)); // stores the total line length of the edge (the hypotenuse, then)
			
			//now let's get ridiculous
			var curr = (p1.z < p2.z) ? p1.z : p2.z; //curr is the current value (starts as the lower of the two line node values)
			var end = (p2.z > p1.z) ? p2.z : p1.z; //end is the end value
			//now find the first interpolated point on the edge segment
		//	trace("curr"+curr+","+Math.floor(curr));
			edge.interPoints = new Array();
			var currInt:Number=Math.floor(curr);
			var curintCeil=currInt+1;
			var m:int=0;
			
			 
			for(m;currInt<curr;m++)
			{
				currInt=Math.floor(curr)+m*interval;
			}
		//	trace("pointsOnEdge"+currInt);
			while (currInt <= end) {
				
				dist = (Math.abs(currInt - currVal) / Math.abs(p1.z - p2.z)) * lineLength;
				
				currPt.x = startPt.x + (dist * Math.cos(angle));
				currPt.y = startPt.y - (dist * Math.sin(angle)) * ymulti;
				 
				var tempt = new InterpolatedPoint(currPt.x, currPt.y, currInt);
				edge.interPoints['pt' + currInt] = tempt;
				 
				currInt+=interval;
				currInt=	Number(currInt.toFixed(1));
				 
				if(currInt>=curintCeil)
				{
					currInt=curintCeil;
					curintCeil++;
				}
			//	trace("     "+currInt);
			}
			//var currInt = curr + (interval - (((curr / interval) - Math.floor(curr/interval)) * interval));
			
			/*******
			****	lame Flash rounding errors (54.99999999999 instead of 55) are screwing this part up
			****	better way of doing this, but for now, I'm just rounding the number if the interval is an integer
			****	SO, if your interval is not an integer, this rounding error thing may screw you up
			****	my solution is lame -- make a better one
			*******/
			/*
			if (interval is int) currInt = Math.round(currInt);
		 
			currInt = Math.ceil(currInt / interval) * interval;
			edge.interPoints = new Array();
	 
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 1;
		 	currInt=Number(nf.format(currInt));
		 
			while (currInt <= end) {
				
				dist = (Math.abs(currInt - currVal) / Math.abs(p1.z - p2.z)) * lineLength;
			 
				currPt.x = startPt.x + (dist * Math.cos(angle));
				currPt.y = startPt.y - (dist * Math.sin(angle)) * ymulti;
			 
				var tempt = new InterpolatedPoint(currPt.x, currPt.y, currInt);
		        edge.interPoints['pt' + currInt] = tempt;
				currInt += interval;
		    
			}*/
		}
		
		/* 
		temporary debugging function labelTris
		
		labels each tri at its bounding box center
		labels with the triangle ID
		*/
		private static function labelTris(tris:Array, points:Array, clip:Group) {
			for (var a in tris) {
				var xxx = new TextField();
				xxx.text = a;
				xxx.x = .5 * (Math.max(points[tris[a].p1].x, points[tris[a].p2].x, points[tris[a].p3].x) - Math.min(points[tris[a].p1].x, points[tris[a].p2].x, points[tris[a].p3].x)) + Math.min(points[tris[a].p1].x, points[tris[a].p2].x, points[tris[a].p3].x);
				xxx.y = .5 * (Math.max(points[tris[a].p1].y, points[tris[a].p2].y, points[tris[a].p3].y) - Math.min(points[tris[a].p1].y, points[tris[a].p2].y, points[tris[a].p3].y)) + Math.min(points[tris[a].p1].y, points[tris[a].p2].y, points[tris[a].p3].y);
				xxx.y = xxx.y * -1;
				xxx.textColor = 0xff0000;
				clip.addElement(xxx); 
			}
		}
	 
		/*
		private static method drawIsolines
		
		takes output of stringIsolines method
		WILL eventually include many options (hypsometric tinting, index lines, color, thickness, etc.)
		*/
		
		public static function drawIsolines(lines:Array, clip:Group, curveStyle:String, colorArray:Array , classesArray:Array, z:Number, angleFactor:Number,xmin:Number,xmax:Number,ymin:Number,ymax:Number,avg:Number,flag:uint) {
			var lefttoppt:Point=new Point(xmin,ymin);
			var righttoppt:Point=new Point(xmax,ymin);
			var leftbottompt:Point=new Point(xmin,ymax);
			var rightbottompt:Point=new Point(xmax,ymax);
			var g:Graphics = clip.graphics;
			lines.sortOn("coordsLen",Array.DESCENDING|Array.NUMERIC);
		    if(flag==0)
		    {
			 g.clear();
			 
			 
			 /*
			 trace("lines    "+lines.length);
			 var i:int=0;
			 for(i=0;i<lines.length;i++)
			 {
			 trace("lines[i].coordsLen"+lines[i].coordsLen+","+lines[i].coords.length);
			 }*/
			 //wholeline represents the average value of the room,it will be drew firstly and it will fill the whole room picture
			 var wholeLine:MyIsoLine=new MyIsoLine;
			 var Mypt1:MyPoint=new MyPoint;
			 Mypt1.x=xmin;
			 Mypt1.y=ymin;
			 Mypt1.z=avg;
			 wholeLine.coords.push(Mypt1);
			 var Mypt2:MyPoint=new MyPoint;
			 Mypt2.x=xmax;
			 Mypt2.y=ymin;
			 Mypt2.z=avg;
			 wholeLine.coords.push(Mypt2);
			 var Mypt4:MyPoint=new MyPoint;
			 Mypt4.x=xmax;
			 Mypt4.y=ymax;
			 Mypt4.z=avg;
			 wholeLine.coords.push(Mypt4);
			 var Mypt3:MyPoint=new MyPoint;
			 Mypt3.x=xmin;
			 Mypt3.y=ymax;
			 Mypt3.z=avg;
			 wholeLine.coords.push(Mypt3);
			 wholeLine.val="pt"+avg;
			 lines.unshift(wholeLine);
			
		    }
			
		
		 
			
			for each(var line in lines) {
				var ptnum;
			 
				if (colorArray!=null && classesArray!=null && colorArray.length == (classesArray.length+1)) { //if we have viable color and class arrays, go ahead with the line tinting
					var val = Number(line.val.substr(2));
				 	trace("val"+val);
					if (val <=classesArray[0]) {
						var classs=0;
					} else if (val >classesArray[classesArray.length-1]) {
						var classs=colorArray.length-1;
					} else {
						for (var cnum=1; cnum <classesArray.length; cnum++) {
							if (val <=classesArray[cnum]) {
								var classs = cnum;
								break;
							}
						}
					}
					// g.lineStyle(5,colorArray[classs]);	
					trace("colorArray[classs]    "+classs);
					 
						g.beginFill(colorArray[classs],0.4);
					 
						
				} else { // otherwise, let's just make these lines red
					g.lineStyle(0, 0xff0000);	}
				switch (curveStyle) { //what kind of scaling do we want, none (rigid), simple (built-in curveTo), or Woody Woodruff's cubicBezier continuous method
					case "none":
						g.moveTo(line.coords[0].x, -line.coords[0].y);
						for (ptnum=1; ptnum<line.coords.length; ptnum++) {
							var pt = new Point(line.coords[ptnum].x,line.coords[ptnum].y);
							g.lineTo(pt.x,pt.y);
						}
						break;
					
					case "simple":
						g.moveTo(line.coords[0].x, -line.coords[0].y);
						for (ptnum=1; ptnum<line.coords.length-2; ptnum++) {
							var pt = new Point(line.coords[ptnum].x,line.coords[ptnum].y);
							var pt1 = new Point(line.coords[ptnum+1].x,line.coords[ptnum+1].y);
							var xc:Number = (pt.x + pt1.x) / 2;
							var yc:Number = (pt.y + pt1.y) / 2;
							g.curveTo(pt.x, pt.y, xc, yc);
						}                
					//	g.curveTo(line.coords[ptnum].x,line.coords[ptnum].y,line.coords[ptnum+1].x,line.coords[ptnum+1].y);
						break;
					
					case "continuous":
						var newPointsArray = new Array();
						/*
						Below is code to connect the interpolated points with a continuous curve, i.e. a smoothed line.
						*/
						for (ptnum=0; ptnum<line.coords.length; ptnum++) {
						 //	trace("continuous"+line.coords[ptnum].x+","+line.coords[ptnum].y);
							if(!isNaN(line.coords[ptnum].x)&&!isNaN(line.coords[ptnum].y))
							{
								 
								newPointsArray.push(new Point(line.coords[ptnum].x, line.coords[ptnum].y));
							}
							else
							{
							//	trace("NaN"+line.coords[ptnum].x+","+line.coords[ptnum].y);
							}
							
						}
						
						CubicBezier.curveThroughPoints(g, newPointsArray, z, angleFactor);
						break;
				} // end of switch statement
			} // end of for loop (for each line)
		} //end of drawIsolines method
		
		
		/*
		private static method stringIsolines
		
		takes an array of edges and strings the isolines (the interval is set above)
		doesn't draw, but creates an array of IsoLine objects which can be passed to drawIsolines method
		*/
		private static function stringIsolines(edges:Array, allTris:Array, points:Array):Array {
			var isolines:Array = new Array(); // will hold the array of isolines, which gets returned	
			//for each edge, and for each interpolated point on the edge, string an isoline (unless it's flagged as killed!!!-- which is to say, an isoline has already been strung through it)
			eachEdge: for (var ekey in edges) { // for each edge
				var edge = edges[ekey];
				var curredge = edge;
				
				
				intOnEdge: for (var intkey in edge.interPoints) { // for each interpolated point on this edge
					var lastTriKey = null;
					if (edge.interPoints[intkey].lineThrough) continue;
					//add the node to the current line
					isolines.push(new MyIsoLine());
					isolines[isolines.length-1].val = intkey;
					isolines[isolines.length-1].coords.push(new Point(edge.interPoints[intkey].x, edge.interPoints[intkey].y));		
					
					var lastekey = null;
					var nextEdge = edge;
					//if we are on the outside, this edge only has one triangle (easy -- don't need to return to this point)
					if (edge.numTris==1) {
						edge.interPoints[intkey].lineThrough = true;
						while (nextEdge != null) {
							nextEdge = oneDirection(nextEdge, intkey);
						}
					} 
						/* 	if we are on the inside, we have two triangles to choose from
						just choose the first one, go as far as you can
						return to original point, take second triangle, go as far as you can
						*/
					else {				
						//first direction (go until stop)
						while (nextEdge != null) {
							nextEdge = oneDirection(nextEdge, intkey);
						}
						//other direction (finish off this isoline)
						edge.interPoints[intkey].lineThrough = true;
						nextEdge = edge;
						while (nextEdge != null) {
							nextEdge = otherDirection(nextEdge, intkey);
						}
					}
					 /*
					if(isolines[isolines.length-1].coords.length>0)
					{
						var isolineLen=isolines.length-1;
						var len:int=isolines[isolineLen].coords.length;
						isolines[isolineLen].coordsLen=0;
						var i:int=1;
						var tempDist:Number=0;
						for(i;i<len;i++)
						{
							tempDist=Point.distance(isolines[isolineLen].coords[0],isolines[isolineLen].coords[i]);
							if(tempDist>isolines[isolineLen].coordsLen)
							{
								isolines[isolineLen].coordsLen=tempDist;
							}
						}
					}*/
					/*
					this method is called if we are heading in the first direction
					can return either an edge (if we're to keep going) or null if we can move on
					*/
					function oneDirection(ee:IEdge,ii:String) {
						//determine which tri we're working with (not the last one!)
						var trinum = ee.tris[(lastTriKey == ee.tris[0]) ? 1 : 0];
						edgeOfTri: for (var ekey2 in allTris[trinum].eArray) { // for each edge of this triangle
							// if this edge IS THE current edge: continue;
							if (edges[allTris[trinum].eArray[ekey2]] == ee) continue;
							var tempEdge = edges[allTris[trinum].eArray[ekey2]];
							//now check this edge to see if it has the same interpolated value
							if (tempEdge.interPoints[ii] && !tempEdge.interPoints[ii].lineThrough) {
								lastTriKey = trinum;
								lastekey = ekey2;
								edges[allTris[trinum].eArray[ekey2]].interPoints[ii].lineThrough = true;
								
								/*******
								 check to make sure we're not storing the same point twice in a row (it happens...)
								 *******/
								
								if (isolines[isolines.length-1].coords[isolines[isolines.length-1].coords.length-1].x != tempEdge.interPoints[ii].x && isolines[isolines.length-1].coords[isolines[isolines.length-1].coords.length-1].y != tempEdge.interPoints[ii].y) {
									isolines[isolines.length-1].coords.push(new Point(tempEdge.interPoints[ii].x, tempEdge.interPoints[ii].y));
								}
								if (tempEdge.numTris == 1) { return null; }
								else { return edges[allTris[trinum].eArray[ekey2]]; }
							}
						}
						return null; //no exit, return null
					} //end of method oneDirection
					
					/*
					this method is nearly identical to the above method, save that it goes in a different direction
					
					frankly, it's ridiculous that this function is here, as it could be gotten rid of by adding/changing a couple parameters of the above method, oneDirection
					*/
					function otherDirection(ee:IEdge, ii:String) {
						//determine which tri we're working with (not the last one!)
						var trinum = ee.tris[(lastTriKey == ee.tris[1]) ? 0 : 1];
						edgeOfTri: for (var ekey2 in allTris[trinum].eArray) { // for each edge of this triangle
							// if this edge IS THE current edge: continue;
							if (edges[allTris[trinum].eArray[ekey2]] == ee) continue;
							var tempEdge = edges[allTris[trinum].eArray[ekey2]];
							//now check this edge to see if it has the same interpolated value
							if (tempEdge.interPoints[ii] && !tempEdge.interPoints[ii].lineThrough) {
								lastTriKey = trinum;
								lastekey = ekey2;
								edges[allTris[trinum].eArray[ekey2]].interPoints[ii].lineThrough = true;
								
								/*******
								 check to make sure we're not storing the same point twice in a row (it happens...)
								 *******/
								
								if (isolines[isolines.length-1].coords[0].x != tempEdge.interPoints[ii].x && isolines[isolines.length-1].coords[0].y != tempEdge.interPoints[ii].y) {
									isolines[isolines.length-1].coords.unshift(new Point(tempEdge.interPoints[ii].x, tempEdge.interPoints[ii].y));
								}
								if (tempEdge.numTris == 1) { return null; }
								else { return edges[allTris[trinum].eArray[ekey2]]; }
							}
						}
						return null; //no exit, return null
						
					} //end of method otherDirection
				} // end of intOnEdge
			} // end of eachEdge
			return isolines;
		} // end of stringIsolines()
		
	} // end of class
} // end of package