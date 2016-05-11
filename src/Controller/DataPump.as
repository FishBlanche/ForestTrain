package Controller
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	 
    import mx.messaging.ChannelSet;
	import mx.messaging.Consumer;
	import mx.messaging.channels.AMFChannel;
    import mx.messaging.events.ChannelEvent;
	import mx.messaging.events.ChannelFaultEvent;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.utils.StringUtil;
    import spark.managers.PersistenceManager;
	import model.SensingEntry;

	public class DataPump  extends EventDispatcher
	{
		public var isConnected:Boolean = false;
	 //all the buffer are located here, from which data for showing is extracted.
	//	public  var sensingBuf:Array = new Array();
		[Bindable]
		public  var newestSensing:SensingEntry = new SensingEntry();
		private var consumer:Consumer=new Consumer();  
	 	private var myAMF:AMFChannel=new AMFChannel();
		private var channelSet:ChannelSet=new ChannelSet();
		private var subscribetimes:int=0;
		private var level:Number;
		private  var serveraddress:PersistenceManager = new PersistenceManager();
		public function DataPump()
		{		
        	if(serveraddress.load())
			{
				if(serveraddress.getProperty("serverAddr"))
				{
					myAMF.url = serveraddress.getProperty("serverAddr") as String;
					channelSet.addChannel(myAMF); 
					consumer.destination="feed";  
					consumer.subtopic="LiveSensing";  
					consumer.channelSet=channelSet;  
					consumer.addEventListener(MessageEvent.MESSAGE, messageHandler);  
					consumer.addEventListener(ChannelFaultEvent.FAULT, fault);  
					consumer.addEventListener(ChannelEvent.CONNECT, connected); 
					consumer.addEventListener(MessageFaultEvent.FAULT, fault2);  
					consumer.subscribe();
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
		
		 
		private function messageHandler(event:MessageEvent):void  
		{  
	      // trace("datapump");
			var entyArray:Array =  StringUtil.trim(event.message.body.toString()).split("|");
			for (var entry:String in entyArray)
			{
				if(entyArray[entry].length< 2) continue;
				var ea:Array = entyArray[entry].split(",");
		        newestSensing.Id = parseInt(ea[0]);
				newestSensing.Cluster_id = parseInt(ea[1]);
				newestSensing.Moteid_ID = parseInt(ea[2]);
			 	newestSensing.TimestampArrive_TM = castMethod1(ea[3]);
				newestSensing.temperature = parseFloat(ea[4]);
				newestSensing.humidity = parseFloat(ea[5]);
				newestSensing.light = parseFloat(ea[6]);	
				newestSensing.co2 = parseFloat(ea[7]);
				newestSensing.type =parseInt(ea[8]);
				newestSensing.path = ea[9];
				//trace("newestSensing.Cluster_id"+newestSensing.Cluster_id);
				level=2*(Math.exp((0.987*Math.log(2+0.001))-0.45-(0.0345*newestSensing.humidity)+(0.0338*newestSensing.temperature)+(0.0234*5)));
				if (Math.round(level) == 0)
					newestSensing.warningLevel = (" NIL");
				else if  (level<5)
					newestSensing.warningLevel =(Math.round(level) + " LOW");
				else if  (level<12)
					newestSensing.warningLevel =(Math.round(level) + " MODERATE"); 
				else if  (level<24)
					newestSensing.warningLevel =(Math.round(level) + " HIGH"); 
				else if  (level<50)
					newestSensing.warningLevel =(Math.round(level) + " VERY HIGH"); 
				else if  (level>50)
					newestSensing.warningLevel=(Math.round(level) + " EXTREME");
				
		        dispatchEvent(new Event("_newSensingData"));
			}
		}  
		private function castMethod1(dateString:String):Date {
			if ( dateString == null ) {
				return null;
			}
			
			var year:int = int(dateString.substr(0,4));
			var month:int = int(dateString.substr(5,2));
			var day:int = int(dateString.substr(8,2));
			
			if ( year == 0 && month == 0 && day == 0 ) {
				return null;
			}
			
			if ( dateString.length == 10 ) {
				return new Date(year, month, day);
			}
			
			var hour:int = int(dateString.substr(11,2));
			var minute:int = int(dateString.substr(14,2));
			var second:int = int(dateString.substr(17,2));
		//	trace(">"+year+ month+day+ hour+ minute+ second);
			return new Date(year, month, day, hour, minute, second);
		}
		private function parseUTCDate( str : String ) : Date {
			var matches : Array = str.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d.\d)Z/);
			
			var d : Date = new Date();
			
			d.setUTCFullYear(int(matches[1]), int(matches[2]) - 1, int(matches[3]));
			d.setUTCHours(int(matches[4]), int(matches[5]), int(matches[6]), 0);
			return d;
		}
		
		
		private function connected(e:ChannelEvent):void  
		{			 
			trace("---connected----");
		}  
		
		
		private function fault(e:ChannelFaultEvent):void  
		{  
			trace("---channel fault----");
	     }  
		
		protected function timer_Handler(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			consumer.subscribe();
			
		}
		
		private function fault2(e:MessageFaultEvent):void  
		{  
			trace("---message fault----");
		 
		}  
		
		
		
	}  

}	
	
