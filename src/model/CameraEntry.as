package model
{
	public class CameraEntry
	{
		private var _Moteid_ID:String ;	
		private var _Location_X:int;
		private var _Location_Y:int ;
		private var _ip_Address:String; 
		
		public function CameraEntry()
		{
		}

		public function get ip_Address():String
		{
			return _ip_Address;
		}

		public function set ip_Address(value:String):void
		{
			_ip_Address = value;
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

		public function get Moteid_ID():String
		{
			return _Moteid_ID;
		}

		public function set Moteid_ID(value:String):void
		{
			_Moteid_ID = value;
		}

	}
}