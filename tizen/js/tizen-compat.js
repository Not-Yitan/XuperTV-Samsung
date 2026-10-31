// Compatibilidad con TV Samsung (Tizen): teclas del mando.
(function () {
  "use strict";
  try {
    if (window.tizen && tizen.tvinputdevice) {
      ["MediaPlay", "MediaPause", "MediaPlayPause", "MediaStop",
       "MediaRewind", "MediaFastForward", "ColorF0Red", "ColorF1Green",
       "ColorF2Yellow", "ColorF3Blue"].forEach(function (k) {
        try { tizen.tvinputdevice.registerKey(k); } catch (e) {}
      });
    }
  } catch (e) {}

  // Tizen: Atras = 10009. La app espera 461 (webOS), asi que se traduce.
  function toBack(e) {
    if (e.keyCode !== 10009 || e.__traducida) return;
    e.preventDefault();
    e.stopPropagation();
    var ev = document.createEvent("Event");
    ev.initEvent(e.type, true, true);
    ev.keyCode = 461;
    ev.which = 461;
    ev.key = "GoBack";
    ev.__traducida = true;
    (document.activeElement || document).dispatchEvent(ev);
  }
  document.addEventListener("keydown", toBack, true);
  document.addEventListener("keyup", toBack, true);
})();
