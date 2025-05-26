import logging
import requests
import os
from flask import Flask, request

# Disable Werkzeug logs
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

app = Flask(__name__)

# executor_url = "http://localhost:8082"
# executor_url = "http://executor-service:8082"
executor_url = os.environ.get("EXECUTOR_URL")
headers = {"Content-Type": "text/plain"}

@app.route('/', methods=['POST'])
def log_message():
    data = request.get_data(as_text=True)
    print(f"{data}", flush=True)
    
    try:
        # Make the POST request
        response = requests.post(executor_url, data=data, headers=headers)

        # Check for HTTP errors
        response.raise_for_status()  # Raises HTTPError for bad responses (4xx or 5xx)

        # Try to parse JSON content
        try:
            result = response.json()
            print("Success:", result)
        except ValueError:
            print("Response is not valid JSON:")
            print(response.text)

    except requests.exceptions.HTTPError as http_err:
        print("HTTP error occurred:", http_err)
        print("Response content:", response.text if 'response' in locals() else 'No response')
    except requests.exceptions.RequestException as req_err:
        print("Request failed:", req_err)
    return "OK\n", 200

if __name__ == '__main__':
    print("📡 Logger service running on port 8081...", flush=True)
    print("📡 Executor service URL:", executor_url, flush=True)
    app.run(host='0.0.0.0', port=8081)
