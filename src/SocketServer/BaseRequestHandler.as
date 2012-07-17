package SocketServer
{
	import flash.net.Socket;

	public class BaseRequestHandler
	{
		public var request:Socket;
		public var client_address : Array;
		public var server:BaseServer;
		
		public function BaseRequestHandler ( request : Socket, client_address : Array, server : BaseServer )
		{
			this.request = request;
			this.client_address = client_address;
			this.server = server;
			
			setup ( );
			handle ( );
			finish ( );
		}
		
		public function setup ( ) : void
		{
			
		}
		
		public function handle ( ) : void
		{
			
		}
		
		public function finish ( ) : void
		{
			
		}
	}
}