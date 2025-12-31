
/*
  Список префиксов настроек:
  
  r_   - Отрисовка изображения у игрока
  pl_  - Параметры сущности игрока (см. в Player)
  w_   - Параметры мира (см. в Map)
  k_   - Клавиши управления и параметры контроллера
  sys_ - Низкоуровневые параметры
  ui_  - Параметры интерфейса
  cam_ - Параметры камеры
*/

boolean r_drawTextures    = false;
color   r_noTextureColor  = #FF7F7F;
boolean r_drawCrosshair   = true;
float   r_crosshairRadius = 5.0;
boolean r_drawMinimap     = true;
float   r_minimapScale    = 10.0;
boolean r_drawSky         = true;
boolean r_debugText       = true;
float   r_renderDist      = 32;
boolean r_drawFog         = true;
color   r_fogColor        = #7F7F7F;
float   r_fogStartDist    = 0;

float   cam_fov = 90;
