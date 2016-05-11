package components
{
	
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	
	import components.SensingDataFormat;
	public class SensorKind
	{
		
		
	//public static var URL:String="http://s.sensehuge.com:8400/dataservices-samples/messagebroker/amf";
		//public static var URL:String="http://192.168.10.148:8080/dataservices-samples/messagebroker/amf";
	//	public static var URL:String="http://172.20.76.251:8080/dataservices-samples/messagebroker/amf";
		//private static var sensorInfo:ArrayCollection = FlexGlobals.topLevelApplication.sensorfeed.sensors;
		public function SensorKind()
		{
		}
		public static function getSensorKind(Moteid_ID:String):int{
			for(var e:Object  in FlexGlobals.topLevelApplication.nodefeed.nodes ){	
				//trace(FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).NodeType);
				if(FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).Moteid_ID==Moteid_ID){
					//trace("**"+FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).NodeType+"**");
					return FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).NodeType;
				}
			}
				return -1;			
		}
		public static function MoteHaveSensor(Moteid_ID:String,sensor:String):Boolean{
			trace(Moteid_ID);
			switch(getSensorKind(Moteid_ID)){
				case 1:
					if(sensor=="tem"||sensor=="hum"){
						return true;
					}else{
						return false;
					}
				case 2:
					if(sensor=="co2"||sensor=="lig"){
						return true;
					}else{
						return false;
					}
				case 3:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"){
						return true;
					}else{
						return false;
					}
				case 4:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}	
				case 6:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}
				case 7:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}	
				case 8:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}
				case 9:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}
				case 11:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}
				case 12:
					if(sensor=="tem"||sensor=="hum"||sensor=="lig"||sensor=="co2"){
						return true;
					}else{
						return false;
					}	
				case 5:
					if(sensor=="tem"||sensor=="hum"||sensor=="co2"){
						return true;
					}else{
						return false;
					}	
				default :
					return false;
			}
			
		}												
		public static function getSensorPos(Moteid_ID:String,w:Number,h:Number):Point{
			for(var e:Object   in FlexGlobals.topLevelApplication.nodefeed.nodes){
				if(FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).Moteid_ID==Moteid_ID){
					return new Point(FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).Location_X*w/1000,FlexGlobals.topLevelApplication.nodefeed.nodes.getItemAt(e).Location_Y*h/1000);
				}
			}
			return new Point(int(Math.random()*(w-100) ),int(Math.random()*(h-100)));
		}
		public static function getUnit(kind:String):String{
			switch(kind){
				case "tem":
					return "(C)";
				case "hum":
					return "(%rh)";
				case "lig":
					return "(lx.)";
				case "co2":
					return "(ppm)";
				case "mag":
					return "(G)";
				default:
					return "(nu)";
			}
		}
	/*	public static function getToolTipMsg(n:Object,kind:String = 'all'):String{
			
				var Msg:String = "";
				
				Msg = "Mote ID: "+n.Moteid_ID;
				if('all'==kind||'tem'==kind)
					Msg +=(SensingDataFormat.temperature(n)=='N/A'?'':("\nTemp.: " +SensingDataFormat.temperature(n)));
				if('all'==kind||'hum'==kind)
					Msg +=(SensingDataFormat.humidity(n)=='N/A'?'':("\nHum.: " +SensingDataFormat.humidity(n)));
				if('all'==kind||'lig'==kind)
					Msg +=(SensingDataFormat.light(n)=='N/A'?'':("\nLight: " +SensingDataFormat.light(n)));
				if('all'==kind||'co2'==kind)
					Msg +=(SensingDataFormat.co2(n)=='N/A'?'':("\nco2: " +SensingDataFormat.co2(n)));
				if('all'==kind||'mag'==kind)
					Msg +=(SensingDataFormat.magStenth(n)=='N/A'?'':("\nMag.: " +SensingDataFormat.magStenth(n)));
					
				return Msg;
				

		}*/
		public static function get_tooltip_msg(n:Object):String{
			var Msg:String = "";		
			Msg = "Mote ID: "+n.Moteid_ID;
			Msg +=(SensingDataFormat.temperature(n)=="N/A"?'':("\nTemp.: " +SensingDataFormat.temperature(n)));
			Msg +=(SensingDataFormat.humidity(n)=="N/A"?'':("\nHum.: " +SensingDataFormat.humidity(n)));
			Msg +=(SensingDataFormat.light(n)=="N/A"?'':("\nLight: " +SensingDataFormat.light(n)));
			Msg +=((SensingDataFormat.co2(n)=="N/A"|| SensingDataFormat.type(n)=="N/A")?'':("\n"+SensingDataFormat.type(n)+": " +SensingDataFormat.co2(n)));
			Msg +=(SensingDataFormat.warningLevel(n)=="N/A"?'':("\nLevel: " +SensingDataFormat.warningLevel(n)));
			return Msg;
		}
	}
}