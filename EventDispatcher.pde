
class EventDispatcher {
  ArrayList<EventListener> listeners;
  
  EventDispatcher() {
    listeners = new ArrayList<>();
  }
  
  void send(Event event) {
    println("Sended Message " + event + " at " + time);
    
    boolean sendEveryone = false;
    if(event.listener == null) sendEveryone = true;
    
    for(EventListener listener : listeners) {
      if(sendEveryone || event.listener == listener) listener.onReceived(event);
    }
  }
}
