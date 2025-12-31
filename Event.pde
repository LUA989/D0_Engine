
class Event {
  EventListener listener; // null - всем слушателям
  Object data;
  Object sender; // null - анонимный отправитель
  
  Event() {
    listener = null;
    data = null;
    sender = null;
  }
  
  Event(EventListener _listener) {
    listener = _listener;
    data = null;
    sender = null;
  }
  
  Event(EventListener _listener, Object _data) {
    listener = _listener;
    data = _data;
    sender = null;
  }
  
  Event(EventListener _listener, Object _data, Object _sender) {
    listener = _listener;
    data = _data;
    sender = _sender;
  }
  
  Event(Event e) {
    listener = e.listener;
    data = e.data;
    sender = e.sender;
  }
  
  String toString() {
    return this.getClass().toString() + "( sender: '" + sender + "', data: '" + data + "', target: '" + listener + "')";
  }
}
