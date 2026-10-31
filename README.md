# Xuper TV para Samsung (Tizen)

Port para TV Samsung de la versión modificada de Xuper TV (`com.notyitan.tv`).

**Créditos:** basado en el port de webOS de **CristianDev**, que autorizó su uso y modificación. Proyecto no oficial, sin relación con Xuper TV, Samsung ni LG. No incluye contenido audiovisual.

## Cómo funciona

Las TV Samsung no pueden ejecutar el servicio Node que en LG corre dentro de la TV. Por eso se divide en dos:

```
TV Samsung (app Tizen, HTML/JS)  ──HTTP──▶  PC / Raspberry Pi (server/)  ──▶  portal
```

- `server/`: el servicio original (`magis.js`, `proxy.js`, relay `ffmpeg`) con un sustituto de `webos-service` que lo expone por HTTP. Solo cambian 3 líneas en `proxy.js` y `ffmpeg-relay.js` (IP pública y `ffmpeg` del sistema).
- `tizen/`: la interfaz de webOS más `config.xml`, y un archivo (`js/tizen-compat.js`) que traduce el botón Atrás de Samsung.

## 1. Servidor (PC con Linux, en la misma red que la TV)

```bash
sudo apt install nodejs ffmpeg
./iniciar-servidor.sh            # detecta la IP sola, o: ./iniciar-servidor.sh 192.168.1.95
curl http://IP_DEL_PC:8910/ping  # debe responder returnValue:true
```

Tiene que quedar encendido mientras uses la app. Puertos: 8910 (API), 8787 (relay) y uno dinámico del proxy; si hay firewall, ábrelos.

## 2. App en la TV

1. `./configurar.sh IP_DEL_PC` (escribe la dirección del servidor en `tizen/config/api.js`).
2. En la TV: Apps → pulsa `12345` en el mando → **Developer mode: On** e introduce la IP de tu PC. Reinicia la TV.
3. Instala [Tizen Studio](https://developer.tizen.org/development/tizen-studio/download) con *TV Extensions*, y crea un certificado Samsung (Certificate Manager).
4. Abre `tizen/` como proyecto Web (o `tizen package -t wgt -- tizen/`), conecta la TV (`sdb connect IP_DE_LA_TV`) y ejecuta *Run As → Tizen Web Application*.

## Estado

- Servidor: probado en Linux (`ping`, sesión y categorías de canales responden).
- App Tizen: **sin probar en una TV Samsung**. Puede necesitar ajustes en el reproductor de video y en el foco del mando.
