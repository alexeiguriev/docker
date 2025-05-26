import logging
from flask import Flask, request

# Disable Werkzeug logs
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

app = Flask(__name__)

@app.route('/', methods=['POST'])
def log_message():
    data = request.get_data(as_text=True)
    print(f"{data}", flush=True)
    return "OK\n", 200

if __name__ == '__main__':
    print("📡 Logger service running on port 8082...", flush=True)
    app.run(host='0.0.0.0', port=8082)
