from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return jsonify({
        'message': 'Hello, teacher!',
        'hostname': hostname,
        'status': 'success'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

@app.route('/info')
def info():
    return jsonify({
        'app': 'Flask Web Application',
        'version': '1.0',
        'server': 'Nginx + Gunicorn'
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
