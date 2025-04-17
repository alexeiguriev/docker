from flask import Flask, request

app = Flask(__name__)

@app.route('/', methods=['POST'])
def log_message():
    try:
        data = request.get_data(as_text=True)
        print(f"📥 Received log: {data}")
    except Exception as e:
        print(f"❌ Error reading POST body: {e}")
    return "OK\n", 200

if __name__ == '__main__':
    print("📡 Logger service running on port 8081...")
    app.run(host='0.0.0.0', port=8081)
