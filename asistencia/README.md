# Asistencia y pagos

Aplicación para registrar entrada y salida del personal, calcular horas extra y estimar el pago semanal del sábado.

## Cálculo

- La jornada normal tiene 8 horas por defecto y el descanso no pagado es 0 minutos. Ambos valores son editables en Configuración.
- Cada persona tiene sueldo semanal fijo y tarifa propia por hora extra. El sueldo semanal se prorratea entre 6 jornadas regulares (lunes a sábado), según la asistencia. La tarifa extra se suma aparte.
- Las horas trabajadas se cuentan entre la entrada y la salida; si se configuró descanso no pagado, se descuenta. El tiempo que supera la jornada normal se considera extra.
- Una jornada sin salida queda indicada como pendiente. El cálculo de horas y horas extra se actualiza al registrar la salida.
- El horario usa la zona `America/Guatemala`. La asistencia se guarda en Supabase para que los dispositivos autorizados vean los mismos datos.

## Activación de la base compartida

1. En el proyecto Supabase `control-camiones`, abre **SQL Editor** y ejecuta `supabase-schema.sql`.
2. En **Authentication → Users**, crea o usa la cuenta que ingresará a la nómina.
3. Copia su UUID y autorízalo con esta consulta:

```sql
insert into public.attendance_app_users (user_id)
values ('UUID-DE-LA-CUENTA-AUTORIZADA')
on conflict (user_id) do nothing;
```

4. Inicia sesión en la app con ese correo y contraseña.

La nómina usa una lista de acceso propia; el acceso a Control de camiones no da acceso automático a sueldos. No agregues a esta lista cuentas que no deban consultar o modificar la nómina.

## Uso

- **Asistencia:** el botón Entrada registra fecha y hora. El botón Salida cierra la jornada y permite detectar horas extra. La toma automática de entrada/salida solo se habilita para la fecha actual; se puede consultar asistencia de otras fechas.
- **Nómina semanal:** muestra días, horas regulares, horas extra y montos por persona para la semana de lunes a sábado seleccionada.
- **Configuración:** define jornada normal, descanso no pagado, jornadas semanales para prorrateo, personas y tarifas. Al desactivar una persona se conserva su historial.

Los totales son estimados según los parámetros configurados por el administrador.
