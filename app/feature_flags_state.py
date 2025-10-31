import threading

_flags_lock = threading.Lock()
_flags = {}

def get_flags():
    with _flags_lock:
        return dict(_flags)

def set_flags(new_flags):
    with _flags_lock:
        global _flags
        _flags = dict(new_flags or {})
