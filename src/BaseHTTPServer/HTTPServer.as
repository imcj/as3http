package BaseHTTPServer
{
	import SocketServer.TCPServer;
	
	public class HTTPServer extends TCPServer
	{
		public function HTTPServer(server_address:Array, RequestHandlerClass:Class, bind_and_activate:Boolean=true)
		{
			super(server_address, RequestHandlerClass, bind_and_activate);
		}
	}
}