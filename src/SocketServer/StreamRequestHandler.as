package SocketServer
{
	import flash.net.Socket;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	public class StreamRequestHandler extends BaseRequestHandler
	{
		public var timeout : int = -1;
		public static const disable_nagle_algorithm : Boolean = false;
		public var connection : Socket;
		public var rfile : IDataInput;
		public var wfile : IDataOutput;
		
		public function StreamRequestHandler(request:Socket, client_address:Array, server:BaseServer)
		{
			super(request, client_address, server);
		}
		
		override public function setup():void
		{
			connection = request;
			if ( timeout )
				connection.timeout = timeout;
			
			rfile = IDataInput ( connection );
			wfile = IDataOutput ( connection );
		}
		
		override public function finish():void
		{
			connection.flush ( ) ;
			connection.close ( );
		}
	}
}