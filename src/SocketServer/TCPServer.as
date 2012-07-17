package SocketServer
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;

	public class TCPServer extends BaseServer
	{
		public var socket : ServerSocket;
		public var request_queue_size : int = 5;
		
		public function TCPServer ( server_address : Array, RequestHandlerClass : Class, bind_and_activate : Boolean = true )
		{
			super ( server_address, RequestHandlerClass );
			socket = new ServerSocket ( );
			
			if ( bind_and_activate ) {
				server_bind ( );
				server_activate ( );
			}
		}
		
		public function server_bind ( ) : void
		{
			socket.bind ( server_address[1], server_address[0] );
			server_address = [ socket.localAddress, socket.localPort ];
			
			socket.addEventListener ( ServerSocketConnectEvent.CONNECT, handlerConnection );
		}
		
		protected function handlerConnection ( event : ServerSocketConnectEvent ) : void
		{
			event.socket.addEventListener ( ProgressEvent.SOCKET_DATA, handlerSocketData );
		}
		
		protected function handlerSocketData ( event : ProgressEvent ) : void
		{
			var client : Socket = Socket ( event.currentTarget );
			process_request ( client, [ socket.localAddress, socket.localPort ] );
		}
		
		override public function server_activate ( ) : void
		{
			socket.listen ( request_queue_size );
		}
		
		override public function server_close ( ) : void
		{
			
		}
		
		public function fileno ( ) : int
		{
			return 0;
		}
		
		public function get_request ( ) : Socket
		{
			return null;
		}
		
		override public function shutdown_request ( request : Socket ) : void
		{
			
		}
		
		override public function close_request ( request : Socket ) : void
		{
			
		}
	}
}