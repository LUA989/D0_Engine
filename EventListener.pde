
class EventListener {
  Consumer<Event> action;
  
  EventListener() {
    action = e -> println("Received Message: " + e + " at " + time);
  }
  
  EventListener(Consumer<Event> _action) {
    action = _action;
  }
  
  void onReceived(Event event) {
    action.accept(event);
  }
}
