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
	
	import model.CameraEntry;
	import model.SensingEntry;

	public class CameraFeed extends EventDispatcher
	{
		private var myAMF:AMFChannel=new AMFChannel();
		private var channelSet:ChannelSet=new ChannelSet();
		private var ro:RemoteObject = new RemoteObject();
		
		public var cameraList:ArrayCollection;
		public function CameraFeed()
		{
			cameraList=new ArrayCollection();
			var serveraddress:PersistenceManager = new PersistenceManager();
			if(serveraddress.load())
			{
				if(serveraddress.getProperty("serverAddr"))
				{
					myAMF.url = serveraddress.getProperty("serverAddr") as String;
					channelSet.addChannel(myAMF); 
					ro.channelSet = channelSet;
					ro.destination = "GettingCameraService";
					ro.addEventListener(ResultEvent.RESULT,ds_resulted,false,0,true);
					ro.getCameras();	
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
		private function ds_resulted(event:ResultEvent):void{
			trace("camera_resulted(event:ResultEvent)");
			cameraList.removeAll();
			for(var e:Object in event.result ){
				//	trace("got  the latest data");
				var st:CameraEntry=new CameraEntry();
				 
				st.Location_X=event.result[e].location_X;
				st.Location_Y=event.result[e].location_Y;
				st.ip_Address=event.result[e].ip;
				trace("st.Location_X   st.Location_Y  st.ip_Address"+st.Location_X+","+st.Location_Y+","+st.ip_Address);
				cameraList.addItem(st);
			}
			trace("cameraList ds resulted hell`````"+cameraList.length);
			dispatchEvent(new Event("_CameraArrived"));
		}
	}
}