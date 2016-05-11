package components
{
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	import mx.utils.StringUtil;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.effects.Fade;
	import spark.effects.Move;
	
	/*draw data routing path
	construct function:DrawDataPath(nodePositionDictionary:Dictionary)
	public variables:
	public functions:  construct function:DrawDataPath(nodePositionDictionary)
	drawPath(moteid:String,icon:Image,dataT:SkinnableContainer):void
	protected variables:
	protected functions:
	*/
	public class DrawDataPath
	{
		//private var feed:SensingFeed=FlexGlobals.topLevelApplication.feed;
		private var nodePositionDictionary:Dictionary;
		private var pathLine:Vector.<RoutingPath>=new Vector.<RoutingPath>();
		private var dataT:Group=null;
		private var newPathNodePosition:Vector.<Point>=new Vector.<Point>();
		[Bindable] [Embed (source="assets/msg/1.png")] private static var msg1:Class;
		[Bindable] [Embed (source="assets/msg/2.png")] private static var msg2:Class;
		[Bindable] [Embed (source="assets/msg/3.png")] private static var msg3:Class;
		[Bindable] [Embed (source="assets/msg/4.png")] private static var msg4:Class;
		[Bindable] [Embed (source="assets/msg/5.png")] private static var msg5:Class;
		/*construct function
		input:nodePositionDictionary
		output:
		*/
		public function DrawDataPath(dat:Group,nodePositionDictionary:Dictionary)
		{		
			this.nodePositionDictionary=nodePositionDictionary;
			dataT=dat;
		}	
		/*draw routing paths in an IVisualElement(UIComponet), and show them in the dataT(SkinnableContainer)
		* input:data source ID,active node icon,dataT(SkinnableContainer)
		output:
		*/
		public function drawPath(moteid:String,path:String,cluster_Id:String):void{	
			var icon :Image= new Image();
		    getPathNode(moteid,path,cluster_Id);		
			if(newPathNodePosition.length>1){
				switch(newPathNodePosition.length){
					case 2:
						icon.source=msg1;
						break;
					case 3:
						icon.source=msg2;
						break;
					case 4:
						icon.source=msg3;
						break;
					case 5:
						icon.source=msg4;
						break;
					default:
						icon.source=msg5;				
				}
				//showRoutingPath(moteid,newPathNodePosition);		
				icon.x = nodePositionDictionary[moteid].x-icon.sourceWidth/2;
				icon.y = nodePositionDictionary[moteid].y-icon.sourceHeight/2;		
				dataT.addElement(icon);	
				var rp:RoutingPath=new RoutingPath(newPathNodePosition);
				rp.depth=1;
				dataT.addElement(rp);
			//	trace("pathLine len"+pathLine.length);
				pathLine.push(rp);	
				if(pathLine.length>15){
					dataT.removeElement(pathLine[0]);
					var temprp:RoutingPath=pathLine.shift();
					temprp=null;
					//		trace("path line was clear"+", path line number="+pathLine.length);
				}								
				var sequence:Sequence = new Sequence();	
				for(var i:int =0 ;i < newPathNodePosition.length-1; i++){							
					var mov:Move = new Move(icon);
					mov.xFrom=newPathNodePosition[i].x-icon.sourceWidth/2;
					mov.yFrom = newPathNodePosition[i].y-icon.sourceHeight/2;
					mov.xTo = newPathNodePosition[i+1].x-icon.sourceWidth/2;
					mov.yTo = newPathNodePosition[i+1].y-icon.sourceHeight/2;
					sequence.addChild(mov);
				}
				var fade:Fade=new Fade(icon);
				fade.alphaFrom=1;
				fade.alphaFrom=0;
				sequence.addChild(fade);
				fade.addEventListener(mx.events.EffectEvent.EFFECT_END,hideIcon,false,0,true);
				//icon.addEventListener(mx.events.EffectEvent.EFFECT_END,hideIcon);
				//	sequence.addEventListener(mx.events.EffectEvent.EFFECT_END,hideIcon);
				sequence.duration=1000;
				sequence.play(); 
			}	
		}
		
		public function hidePath():void{
			for(var i:int=0;i<pathLine.length;i++){
				dataT.removeElement(pathLine[i]);
			}
			pathLine.splice(0-pathLine.length,pathLine.length);
			//	trace("hide all trace path");
		}
		private function hideIcon(event:EffectEvent):void{
			var icon:Image=event.target.target as Image;
			if(dataT.owns(icon)){
				dataT.removeElement(icon);	
				
			}
		}
		private function getPathNode(dataSourceID:String,path:String,cluster_Id:String):void{
		//	var newPathNodePosition:Array=new Array();
			//trace(newPathNodePosition.length);
			var pathnodePositionLen:int=newPathNodePosition.length;
			
			for(var j:int =0 ;j < pathnodePositionLen; j++){
				newPathNodePosition.pop();
			}
			var pathNodeID:Array =  StringUtil.trim(path).split(" ");
			newPathNodePosition[0]=nodePositionDictionary[dataSourceID] as Point;
			for(var i:int =1 ;i < pathNodeID.length+1; i++){
				if(pathNodeID[i-1]!="0"){
					if(nodePositionDictionary[pathNodeID[i-1]]!=null){
						newPathNodePosition.push(nodePositionDictionary[pathNodeID[i-1]] as Point);
					}
				}else{
					
					break;
				}
				
				//trace(i+" "+pathNodeID[i-1]);			
			}
			if(nodePositionDictionary[cluster_Id]!=null){
				newPathNodePosition.push(nodePositionDictionary[cluster_Id] as Point);
			}
			
		}
	 
	}
	
}

