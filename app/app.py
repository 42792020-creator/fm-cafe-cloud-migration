from flask import Flask, jsonify
from app.read_feature_flags import get_feature_flags as load_flags_from_source
from app.feature_flags_state import get_flags, set_flags
import threading, time

app = Flask(__name__)
REFRESH_INTERVAL = 30  # seconds

def refresh_loop():
    while True:
        try:
            flags = load_flags_from_source()
            if flags:
                set_flags(flags)
                app.logger.info("Feature flags refreshed: %s", flags)
        except Exception as e:
            app.logger.warning("Failed to refresh flags: %s", e)
        time.sleep(REFRESH_INTERVAL)

@app.before_first_request
def start_background_refresh():
    flags = load_flags_from_source()
    set_flags(flags or {})
    t = threading.Thread(target=refresh_loop, daemon=True)
    t.start()

@app.route("/")
def index():
    flags = get_flags()
    if flags.get("maintenance_mode"):
        return "Maintenance in progress", 503
    if flags.get("enable_new_checkout"):
        return "NEW checkout UI (placeholder)"
    return "Old checkout UI (placeholder)"

@app.route("/flags")
def show_flags():
    return jsonify(get_flags())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
