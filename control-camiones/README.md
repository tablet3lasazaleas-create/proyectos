# Control de camiones

Aplicación para registrar distribuidores, camiones por placa y movimientos de ingreso y egreso. Cada tarjeta muestra el conteo independiente de camionadas: se cuenta cada ingreso asociado a ese camión una sola vez. La pestaña **Asistencia de camiones** registra por fecha si cada camión vino y cuántas camionadas hizo; estos datos también se comparten entre dispositivos.

Los registros se comparten entre dispositivos mediante el proyecto Supabase `control-camiones`. La app requiere una cuenta autorizada y conserva copia local. Los movimientos nuevos se sincronizan al espacio compartido y se actualizan en otros dispositivos abiertos.

En la pestaña **Administrar** puedes cambiar el distribuidor, la placa y la tarifa por camionada de cada camión, quitar camiones conservando su historial y eliminar movimientos incorrectos. Las eliminaciones y tarifas se sincronizan entre dispositivos.

Al agregar o editar un camión, define su tarifa habitual por camionada en quetzales. Al registrar cada ingreso o egreso, el monto se propone con esa tarifa y puedes ajustarlo para ese movimiento. El historial conserva el monto registrado; cada tarjeta suma los movimientos del camión y el dashboard muestra la suma acumulada de todos los montos registrados (ingresos más egresos).

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
