# Actividad 2: Automatización y Comportamiento Autónomo en CoppeliaSim

#### **Autor:** Josue Guadalupe Hernandez Perez
#### **Autor:** Rendon Hernandez Christopher


Este proyecto presenta una estación de trabajo automatizada que integra un brazo robótico, un sistema de transporte y sensores inteligentes para la clasificación de objetos por color en un entorno dinámico.

## 1. Descripción del Comportamiento Autónomo
El sistema opera bajo un lazo de control cerrado y autónomo mediante una **Máquina de Estados Finitos (FSM)**. La secuencia lógica se ejecuta sin intervención manual tras iniciar la simulación:

1.  **Detección:** El `sensorRay` monitorea constantemente la banda transportadora.
2.  **Reacción Sensorial:** Al detectar un objeto con el alias "verde", el script del sensor detiene inmediatamente la banda transportadora (`conveyor`) y envía una señal de activación (`activarBrazo`) al manipulador.
3.  **Ejecución de Trayectoria:** El brazo robótico transita por los estados `cerrar` -> `empujar` -> `regresarPunta` -> `abrir` para desplazar el objeto fuera de la línea.
4.  **Retorno a Estado Seguro:** Una vez finalizada la tarea, el brazo regresa a su posición `idle` y la banda reanuda su movimiento automáticamente para esperar el siguiente objeto.

## 2. Sensores e Interacción con el Entorno
Se ha integrado un **Sensor de Proximidad Inteligente (`sensorRay`)** que permite la interacción reactiva:
* **Tipo de sensor:** Sensor de proximidad de rayo.
* **Lógica de decisión:** Filtrado por metadatos de objeto (`sim.getObjectAlias`). El sistema identifica si la caja es "roja" o "verde".
* **Comportamiento reactivo:** 
    * **Verde:** Parada de emergencia de la banda y activación de secuencia de clasificación.
    * **Rojo:** El sistema lo ignora, permitiendo que continúe su flujo, cumpliendo con la lógica de discriminación de objetivos.

## 3. Parámetros Críticos y Umbrales
Para garantizar la estabilidad de la simulación, se han configurado los siguientes parámetros:

| Parámetro | Valor | Descripción |
| :--- | :--- | :--- |
| **Umbral de Distancia** | `< 0.05 m` | Distancia mínima para validar la detección de una caja. |
| **Velocidad Banda** | `0.1 m/s` | Velocidad nominal para evitar deslizamientos de carga. |
| **Intervalo FSM** | `0.5 s` | Tiempo de espera entre movimientos del brazo para evitar colisiones inerciales. |
| **Frecuencia Spawn** | `3.0 s` | Tiempo entre la creación de nuevos objetos sobre la banda. |

## 4. Registro de Pruebas

| Escenario | Condición Inicial | Resultado Observado | Ajuste Realizado |
| :--- | :--- | :--- | :--- |
| **1. Secuencia Base** | Cajas individuales (rojo/verde). | El sistema detiene la banda solo ante cajas verdes y ejecuta el empuje. | Sincronización del tiempo de cerrado del dedo (`joint1`). |
| **2. Obstáculo Frontal** | Acumulación de cajas (Sobre carga). | El sensor detecta la saturación y mantiene la banda detenida. | Ajuste de fricción en la banda para evitar que las cajas "patinen" (Evidencia: `Caso 1 sobre carga.png`). |
| **3. Terreno/Carga Irregular** | Cajas generadas aleatoriamente. | Estabilidad mantenida en la detección; los objetos rojos fluyen sin activar el brazo. | Reajuste de la altura del sensor para evitar lecturas de la banda misma. |

## 5. Evidencia Visual
* **Vista General:** Imagen de la jerarquía completa y el entorno de la banda.
<img width="1918" height="852" alt="image" src="https://github.com/user-attachments/assets/7a736e9b-2c25-4158-beff-10c154ab11ff" />

* **Primer Plano del Sensor:** Capturas detalladas en la carpeta `/Evidencia` mostrando la interacción con objetos verdes y rojos bajo condiciones de sobrecarga.

***

### Notas:
* Se utilizó **Lua (Child Scripts)** para el control interno por su baja latencia en la respuesta a sensores.
* El control de las juntas se realiza mediante `sim.setJointTargetPosition`, asegurando movimientos suaves y controlados.
