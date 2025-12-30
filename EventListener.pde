
class EventListener {
  Consumer<Event> action;
  
  EventListener() {
    action = e -> {};
  }
  
  EventListener(Consumer<Event> _action) {
    action = _action;
  }
  
  void onReceived(Event event) {
    action.accept(event);
  }
}
