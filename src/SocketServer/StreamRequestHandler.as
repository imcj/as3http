package SocketServer
{
	import flash.net.Socket;
	
	public class StreamRequestHandler extends BaseRequestHandler
	{
		public var timeout : int = -1;
		
		public function StreamRequestHandler(request:Socket, client_address:Array, server:BaseServer)
		{
			super(request, client_address, server);
		}
	}
}