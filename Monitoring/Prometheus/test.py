import http.server
from prometheus_client import start_http_server

class ServerHandler(http.server.BaseHTTPRequestHandler):
  def do_GET(self):
    self.send_response(200)
    self.end_headers()
    self.wfile.write(b"Hello World!")

if __name__ == '__main__':
  start_http_server(8000)
  server = http.server.HTTPServer(('', 8001), ServerHandler)
  print("Prometheus metrics available on port 8000 /metrics")
  print("HTTP server available on port 8001")
  server.serve_forever()
