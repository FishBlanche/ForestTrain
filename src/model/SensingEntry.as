package model
{
	[Bindable]
	//[RemoteClass(alias="flex.samples.product.SensingEntry")]
	public class SensingEntry{
		public var Id:int = 0;
		public var Cluster_id:int = 0;
		public var Moteid_ID:int = 0;	
		public var TimestampArrive_TM:Date;
		public var temperature:Number = 0.0;
		public var humidity:Number = 0.0;
		public var light:Number = 0.0;		
		public var co2:Number = 0.0;	
		public var path:String;
		public var type: int = 0;
		public var warningLevel:String="";
		public function SensingEntry()
		{
			Id = 0;
			Cluster_id = 0;
			Moteid_ID = 0;
			TimestampArrive_TM = null;
			temperature= 0.0;
			humidity = 0.0;
			light = 0.0;	
			co2 = 0;
			path="";
			type = 0;
		}
	}


}