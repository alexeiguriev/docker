from flask import Flask, request

app = Flask(__name__)

@app.route('/', methods=['POST'])
def log_message():
    data = request.get_data(as_text=True)
    print(f"📥 Received log: {data}")
    return "OK\n", 200

if __name__ == '__main__':
    print("📡 Logger service running on port 8081...")
    app.run(host='0.0.0.0', port=8081)
