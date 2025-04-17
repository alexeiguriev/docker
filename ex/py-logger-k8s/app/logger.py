from flask import Flask, request
from datetime import datetime

app = Flask(__name__)
LOG_FILE = "/logs/requests.log"

@app.route('/', methods=['POST'])
def log_message():
    data = request.get_data(as_text=True)
    timestamp = datetime.utcnow().isoformat()

    log_entry = f"[{timestamp}] {data}"
    
    # Log to stdout
    print(f"📥 Received log: {log_entry}")

    # Log to file
    try:
        with open(LOG_FILE, "a") as f:
            f.write(log_entry + "\n")
    except Exception as e:
        print(f"❌ Failed to write to log file: {e}")

    return "OK\n", 200

if __name__ == '__main__':
    print("📡 Logger service running on port 8081...")
    app.run(host='0.0.0.0', port=8081)
