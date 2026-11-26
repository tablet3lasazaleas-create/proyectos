# Control de camiones

Aplicación para registrar distribuidores, camiones por placa y movimientos de ingreso y egreso. Cada tarjeta muestra el conteo independiente de camionadas: se cuenta cada ingreso asociado a ese camión una sola vez.

Los registros se comparten entre dispositivos mediante el proyecto Supabase `control-camiones`. La app requiere una cuenta autorizada y conserva copia local. Los movimientos nuevos se sincronizan al espacio compartido y se actualizan en otros dispositivos abiertos.

En la pestaña **Administrar** puedes cambiar el distribuidor y la placa de cada camión, quitar camiones conservando su historial y eliminar movimientos incorrectos. Las eliminaciones se sincronizan entre dispositivos.

## Acceso compartido

- Proyecto Supabase: `control-camiones` (`edakzkemdlgsbirikems`).
- Las tablas `truck_app_state` y `truck_app_users` se crean con [`supabase/schema.sql`](supabase/schema.sql); RLS limita el acceso a cuentas autorizadas.
- Para añadir otra cuenta, crea un usuario en **Authentication → Users**, activa **Auto confirm**, y agrega su UUID a `public.truck_app_users` desde SQL Editor:

```sql
insert into public.truck_app_users (user_id)
values ('UUID-DEL-USUARIO')
on conflict (user_id) do nothing;
```

- Inicia sesión en la app con el correo y contraseña de esa cuenta desde cada dispositivo.
- Si un dispositivo ya tenía información local, usa **Importar datos de este dispositivo** para agregarla a la base compartida.

`supabase-config.js` contiene únicamente la URL del proyecto y su publishable key. Estas pueden estar en el frontend porque Row Level Security está activo. No publicar contraseñas de base de datos ni claves `secret` o `service_role`.
