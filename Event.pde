
enum EventType {
  GENERIC
}

class Event {
  EventType type;
  EventListener listener; // null - всем слушателям
  Object data;
  Object sender; // null - анонимный отправитель
  
  Event() {
    type = EventType.GENERIC;
    listener = null;
    data = null;
    sender = null;
  }
  
  Event(EventType _type) {
    type = _type;
    listener = null;
    data = null;
    sender = null;
  }
  
  Event(EventType _type, EventListener _listener, Object _data) {
    type = _type;
    listener = _listener;
    data = _data;
    sender = null;
  }
  
  Event(EventType _type, EventListener _listener, Object _data, Object _sender) {
    type = _type;
    listener = _listener;
    data = _data;
    sender = _sender;
  }
}
