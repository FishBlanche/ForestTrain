package model
{

	[Bindable]
	public class NodeEntry
	{
		private var _Moteid_ID:String ;	
		private var _NodeType:int;
		private var _Location_X:int;
		private var _Location_Y:int ;
		private var _Latitude:Number;
		private var _longitude:Number;
		private var _remarks:String;
		
		
		public function NodeEntry()
		{
			Moteid_ID="";
			NodeType=0;
			Location_X=0
			Location_Y=0;
			Latitude=0.0;
			longitude=0.0;
			remarks="";
		
			
		}
		/*	public function  SensorEntry(id:int,userid:int,Moteid_ID:int,type:int,Location_X:int,Location_Y:int,Latitude:Number,longitude:Number,remarks:String){
		this.id=id;
		}*/
		
		
		


		public function get remarks():String
		{
			return _remarks;
		}

		public function set remarks(value:String):void
		{
			_remarks = value;
		}

		public function get longitude():Number
		{
			return _longitude;
		}

		public function set longitude(value:Number):void
		{
			_longitude = value;
		}

		public function get Location_Y():int
		{
			return _Location_Y;
		}

		public function set Location_Y(value:int):void
		{
			_Location_Y = value;
		}

		public function get Location_X():int
		{
			return _Location_X;
		}

		public function set Location_X(value:int):void
		{
			_Location_X = value;
		}

		public function get NodeType():int
		{
			return _NodeType;
		}

		public function set NodeType(value:int):void
		{
			_NodeType = value;
		}

		public function get Moteid_ID():String
		{
			return _Moteid_ID;
		}

		public function set Moteid_ID(value:String):void
		{
			_Moteid_ID = value;
		}

		public function get Latitude():Number
		{
			return _Latitude;
		}

		public function set Latitude(value:Number):void
		{
			_Latitude = value;
		}

	}
}