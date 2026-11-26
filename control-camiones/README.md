# Control de camiones

Aplicación para registrar distribuidores, camiones por placa y movimientos de ingreso y egreso. Cada tarjeta muestra el conteo independiente de camionadas: se cuenta cada ingreso asociado a ese camión una sola vez.

Los registros se comparten entre dispositivos mediante Supabase. Para usar la aplicación, inicia sesión con una cuenta autorizada; la app conserva una copia local y sincroniza los cambios con los demás dispositivos.

## Acceso compartido

- Proyecto Supabase: `control-camiones` (`edakzkemdlgsbirikems`).
- Las tablas `truck_app_state` y `truck_app_users` se crean con [`supabase/schema.sql`](supabase/schema.sql); las políticas RLS limitan el acceso a cuentas autorizadas.
- Para autorizar otra cuenta, créala en Supabase **Authentication → Users**, marca **Auto confirm**, y agrega su UUID a `public.truck_app_users` desde SQL Editor:

```sql
insert into public.truck_app_users (user_id)
values ('UUID-DEL-USUARIO')
on conflict (user_id) do nothing;
```

- Inicia sesión en la app con el correo y contraseña de esa cuenta desde cada dispositivo.
- Si un dispositivo ya tenía información local, usa **Importar datos de este dispositivo** para agregarla a la base compartida.

`supabase-config.js` contiene la URL del proyecto y su publishable key. La key puede estar en el frontend porque Row Level Security está activo. No publiques contraseñas de base de datos ni claves `secret` o `service_role`. 
