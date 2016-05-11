package Controller
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	 
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.managers.PersistenceManager;
	
	 

	public class CameraPicturesFeed extends EventDispatcher
	{
		private var myAMF:AMFChannel=new AMFChannel();
		private var channelSet:ChannelSet=new ChannelSet();
		private var ro:RemoteObject = new RemoteObject();
		public var cameraPicList:Array;
		
		public function CameraPicturesFeed()
		{
			cameraPicList=new Array;
			var serveraddress:PersistenceManager = new PersistenceManager();
			if(serveraddress.load())
			{
				if(serveraddress.getProperty("serverAddr"))
				{
					myAMF.url = serveraddress.getProperty("serverAddr") as String;
					channelSet.addChannel(myAMF); 
					ro.channelSet = channelSet;
					ro.destination = "GettingCameraPictureService";
					ro.addEventListener(ResultEvent.RESULT,ds_resulted,false,0,true);
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
		
		
		public function getCameraPicByIp(ipStr:String):void
		{
			ro.getCameraPicturesByIp(ipStr);
		}
		public function getCameraPicByIpAndTime(ipStr:String,startdate:String,enddate:String):void
		{
			ro.getCameraPicturesByIpAndDate(ipStr,startdate,enddate)
		}
		private function ds_resulted(event:ResultEvent):void{
			trace("CameraPictures  ds_resulted(event:ResultEvent)");
			var listlen:int=cameraPicList.length;
			var i:int;
			for(i=0;i<listlen;i++)
			{
				cameraPicList.pop();
			}
		 
			for(var e:Object in event.result ){
				//	trace("got  the latest data");
				var st:String=new String;
				st= event.result[e];
				cameraPicList.push(st);
			}
			trace("ds resulted hell`````"+cameraPicList.length);
			dispatchEvent(new Event("_CameraPicturesArrived"));
		}
	}
}