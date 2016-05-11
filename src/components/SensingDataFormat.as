package components
{
	import flashx.textLayout.formats.Float;
	
	import mx.formatters.NumberFormatter;


	public  class SensingDataFormat
	{
		protected static var nf:NumberFormatter = new NumberFormatter();
		nf.precision = 1;
		
		protected static var nf_mag:NumberFormatter = new NumberFormatter();
		nf_mag.precision = 3;
		
		public static var deString:String = "N/A";
		public function SensingDataFormat()
		{
			
		}
		
		public static function light( v:Object):String{
			if(!v.hasOwnProperty("light"))
				return deString;
			var res:String  = v.light<0.1 || v.light>500.0 ?  deString :  nf.format(v.light);
	        return res;
		}
		public static function humidity(v:Object):String{
			if(!v.hasOwnProperty("humidity")) return deString;
			var res:String  =(v.humidity<5.0 || v.humidity>100.0)? deString :  nf.format(v.humidity);
			return res;
		}
		public static function temperature(v:Object):String{
			if(!v.hasOwnProperty("temperature")) return deString;
			var res:String  =(v.temperature<0.01 || v.temperature>50.0)? deString : nf.format(v.temperature);
			return res;
		}
		public static function warningLevel(v:Object):String{
			if(!v.hasOwnProperty("warningLevel")) return deString;
			var res:String  =v.warningLevel;
			return res;
		}
		public static function co2(v:Object):String{
			if(!v.hasOwnProperty("co2")) return deString;
		//	if(v.Moteid_ID<8000 || v.Moteid_ID >10000) return deString;
		//	var res:String  =(v.co2<0.01 || v.co2>2500.0)? deString : nf.format(v.co2);
		
	//		var res:String =  nf.format(v.co2);
			
			if(!v.hasOwnProperty("type")) return deString;
			var res:String  = v.type;
			switch(res)
			{
				case "1":
				 
					res =  nf.format(Number(v.co2)*2048.0/32767*0.199204-224.1) ;
					break;
				 
				case "2":
				{
					res= nf.format(v.co2);
					break;
				}
				case "3":
				 
					res=nf.format( (Number(v.co2) * (2048.0/32767)) * (20/923) - 24.3716);
					break;
				 
				case "4":
				{
					res=nf.format(v.co2);
					break;
				}
				case "5":
				{
					res=nf.format(v.co2);
					break;
				}
				case "6":
				{
					res=nf.format(v.co2);
					break;
				}
				case "7":
				{
					if(Number(v.co2) < 983.04) {
						res=nf.format(Math.random());
					}
					else{
						res= nf.format(Number(v.co2)*( 983.04/983.4) - 13.29);
					}
					return res;
					break;
				}
					
				default:
				{
					res="0";
					break;
				}
			}
			return res;
		}
		
		public static function magStenth(v:Object):String{
			return deString;
/*			if(!v.hasOwnProperty("co2")) return deString;
		//	if(v.Moteid_ID<10000 || v.Moteid_ID >12000) return deString;
			var mag:Number = v.co2/1090;//convert to gauss
			var res:String  =(mag< 0.0 || mag>5.0)? deString : nf_mag.format(mag);
			return res;*/
		}
		public static function type(v:Object):String{
			if(!v.hasOwnProperty("type")) return deString;
			var res:String  = v.type;
			switch(res)
			{
				case "1":
				{
					res="CO";
					break;
				}
				case "2":
				{
					res="CO2";
					break;
				}
				case "3":
				{
					res="SO2";
					break;
				}
				case "4":
				{
					res="NO2";
					break;
				}
				case "5":
				{
					res="NO2";
					break;
				}
				case "6":
				{
					res="CH4";
					break;
				}
				case "7":
				{
					res="DUST";
					break;
				}
					
				default:
				{
					res="N/A";
					break;
				}
			}
			return res;
		}
	}
}