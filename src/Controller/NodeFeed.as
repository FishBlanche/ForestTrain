// ActionScript file
package Controller
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	 
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
 
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.managers.PersistenceManager;
	
	import model.NodeEntry;
	
	public class NodeFeed  extends EventDispatcher
	{
		
		[Bindable]
		public var nodes:ArrayCollection ;
		private var myAMF:AMFChannel=new AMFChannel();
		private var channelSet:ChannelSet=new ChannelSet();
		private var ro:RemoteObject = new RemoteObject();
		private  var serveraddress:PersistenceManager = new PersistenceManager();
		public function NodeFeed(){
			nodes = new ArrayCollection();
			if(serveraddress.load())
			{
				if(serveraddress.getProperty("serverAddr"))
				{
					myAMF.url = serveraddress.getProperty("serverAddr") as String;
					channelSet.addChannel(myAMF); 
					ro.channelSet = channelSet;
					ro.destination = "NodeInfoService";
					ro.addEventListener(ResultEvent.RESULT,deploySensor_resultHandler,false,0,true);
					ro.getNodeList();
				}
				else
				{
					trace("myAMF.url未知");
				}
			}
			else
			{
				trace("myAMF.url未知");
			}
		
		}
		
		public function refresh():void{
			ro.getNodeInfos();
		}
		
		private function deploySensor_resultHandler(event:ResultEvent):void
		{
			// TODO Auto-generated method stub
			 
			for(var e:Object in event.result )
			{
			 
			var st:NodeEntry = new NodeEntry();
			st.Moteid_ID=event.result[e].moteid_ID.toString();
		    st.NodeType=event.result[e].nodeType;
		    st.Location_X=event.result[e].location_X;
			st.Location_Y=event.result[e].location_Y;
			st.Latitude=event.result[e].latitude;
			st.longitude=event.result[e].longitude;
		    st.remarks=event.result[e].remarks;
			
		//	trace(st.Moteid_ID +"  "+st.NodeType+"  "+st.Location_X+"  "+st.Location_Y );
			nodes.addItem(st);
	       }
			trace("nodes ok```"+nodes.length);
			dispatchEvent(new Event("_SensingNode"));
			 
			
		}
		 
	}

}