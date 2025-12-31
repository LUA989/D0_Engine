
class EngineEvent extends Event {
  EngineEvent(Event e) {
    super(e);
  }
}
class GameEvent extends Event {
  GameEvent(Event e) {
    super(e);
  }
}

class EngineInitializedEvent extends EngineEvent {
  EngineInitializedEvent(Event e) {
    super(e);
  }
}

class EngineChangeStateEvent extends EngineEvent {
  EngineChangeStateEvent(Event e) {
    super(e);
  }
}

class RenderEvent extends EngineEvent {
  RenderEvent(Event e) {
    super(e);
  }
}
class GUIEvent extends EngineEvent {
  GUIEvent(Event e) {
    super(e);
  }
}

class CameraFrameDrawedEvent extends EngineEvent {
  CameraFrameDrawedEvent(Event e) {
    super(e);
  }
}
class DrawedGUIEvent extends GUIEvent {
  DrawedGUIEvent(Event e) {
    super(e);
  }
}

class KeyPressedEvent extends EngineEvent {
  KeyPressedEvent(Event e) {
    super(e);
  }
}
class KeyReleasedEvent extends EngineEvent {
  KeyReleasedEvent(Event e) {
    super(e);
  }
}
