/** 
 * Christophe Coenraets, http://coenraets.org
 */
package Controller
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.PropertyChangeEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.managers.PersistenceManager;
	
	import Controller.DataPump;
	
	import model.SensingEntry;
	 

	public class SensingFeed extends EventDispatcher
	{
		 
		protected static var nf:NumberFormatter = new NumberFormatter();
		nf.precision = 1;
		 
		[Bindable]
		public var newestSensingList:ArrayCollection;
		public var newestSensingListCollect:ArrayCollection;
		private  var datapump:DataPumpHelper  = new DataPumpHelper();
		private  var datap:DataPump = datapump.getDataPump();
		
		private var myAMF:AMFChannel=new AMFChannel();
		private var channelSet:ChannelSet=new ChannelSet();
		private var ro:RemoteObject = new RemoteObject();
		 
		private	var timer:Timer;
		private var level:Number;
		public function SensingFeed()
		{
			newestSensingList = new ArrayCollection();
			newestSensingListCollect=new ArrayCollection();
			datap.addEventListener("_newSensingData",newData,false,0,true);
			var serveraddress:PersistenceManager = new PersistenceManager();
			if(serveraddress.load())
			{
				if(serveraddress.getProperty("serverAddr"))
				{
					myAMF.url = serveraddress.getProperty("serverAddr") as String;
					trace("myAMF.url"+myAMF.url);
					channelSet.addChannel(myAMF); 
					ro.channelSet = channelSet;
					ro.destination = "NewestSensingService";
					ro.addEventListener(ResultEvent.RESULT,ds_resulted,false,0,true);
					ro.getNewestSensings();	
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
			ro.getNewestSensings();	
		}
		
		private function property_change(event:Event):void{
			trace("ds property changed `````");
		}
		private function ds_resulted(event:ResultEvent):void{
		 //   trace("ds_resulted(event:ResultEvent)");
			newestSensingList.removeAll();
			for(var e:Object in event.result ){
			 //	trace("got  the latest data");
				var st:SensingEntry = new SensingEntry();
				st.Id = event.result[e].Id;
				st.Cluster_id = event.result[e].Cluster_id;
				st.Moteid_ID = event.result[e].nodeid;
				st.TimestampArrive_TM = event.result[e].TimestampArrive_TM;
				st.humidity = event.result[e].humidity;
				st.temperature= event.result[e].temperature;
				st.light = event.result[e].light;
				st.type = event.result[e].type;
				st.co2 = event.result[e].co2;	
				//trace("got  the latest data"+st.Moteid_ID);
				level=2*(Math.exp((0.987*Math.log(2+0.001))-0.45-(0.0345*st.humidity)+(0.0338*st.temperature)+(0.0234*5)));
				if (Math.round(level) == 0)
					st.warningLevel = (" NIL");
				else if  (level<5)
					st.warningLevel =(Math.round(level) + " LOW");
				else if  (level<12)
					st.warningLevel =(Math.round(level) + " MODERATE"); 
				else if  (level<24)
					st.warningLevel =(Math.round(level) + " HIGH"); 
				else if  (level<50)
					st.warningLevel =(Math.round(level) + " VERY HIGH"); 
				else if  (level>50)
					st.warningLevel=(Math.round(level) + " EXTREME");

 				newestSensingList.addItem(st);
			}
		 	trace("ds resulted hell`````"+newestSensingList.length);
		 
			 
	    }
		protected function newData(event:Event):void{
		 //	trace("SensingFeed newData");
			var sense:SensingEntry  = datapump.getDataPump().newestSensing;
			var stockCount:int = newestSensingList.length;
			for (var k:int = 0; k < stockCount; k++)
			{
				if(newestSensingList.getItemAt(k).Moteid_ID== sense.Moteid_ID){
				    newestSensingList.getItemAt(k).temperature=sense.temperature;
					newestSensingList.getItemAt(k).humidity=sense.humidity;
					newestSensingList.getItemAt(k).light=sense.light;	
					newestSensingList.getItemAt(k).co2=sense.co2;
					newestSensingList.getItemAt(k).type = sense.type;
					newestSensingList.getItemAt(k).warningLevel=sense.warningLevel;
				//	newestSensingList.itemUpdated(newestSensingList.getItemAt(k));
					break;
				}
			}
			
		}

	}
}