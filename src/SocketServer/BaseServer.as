package SocketServer
{
	import BaseHTTPServer.BaseHTTPRequestHandler;
	
	import flash.net.Socket;
	
	import mx.core.ClassFactory;
	import mx.events.Request;

	public class BaseServer
	{
		public var server_address : Array;
		public var RequestHandlerClass : Class;
		
		public function BaseServer ( server_address : Array, RequestHandlerClass : Class )
		{
			this.server_address = server_address;
			this.RequestHandlerClass = RequestHandlerClass;
		}
		
		public function server_activate ( ) : void
		{
			
		}
		
		public function serve_forever ( poll_interval : int = -1 ) : void
		{
			
		}
		
		public function shutdown ( ) : void
		{
			
		}
		
		public function handle_request ( ) : void
		{
			
		}
		
		private function _handle_request_noblock ( ) : void
		{
		}
		
		public function handle_timeout ( ) : void
		{
			
		}
		
		public function verify_request ( request : Socket, client_address : Array ) : Boolean
		{
			return true;	
		}
		
		public function process_request ( request : Socket, client_address : Array ) : void
		{
			finish_request ( request, client_address );
			shutdown_request ( request );
		}
		
		public function server_close ( ) : void
		{
			
		}
		
		public function finish_request ( request : Socket, client_address : Array ) : void
		{
			new RequestHandlerClass ( request, client_address, this );
		}
		
		public function shutdown_request ( request : Socket ) : void
		{
			close_request ( request );
		}
		
		public function close_request ( request : Socket ) : void
		{
			
		}
		
		public function handle_error ( request : Socket, client_address : Array ) : void
		{
			
		}
	}
}