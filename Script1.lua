function sysCall_init()
    sim = require('sim')

    joint1 = sim.getObject('/joint1')
    joint2 = sim.getObject('/joint2')

    estado = "idle"
    tiempoInicio = 0
end


function sysCall_actuation()

    local t = sim.getSimulationTime()

    -- Leer se?al del sensor
    local activar = sim.getInt32Signal("activarBrazo")

    if activar == 1 and estado == "idle" then
        estado = "cerrar"
        tiempoInicio = t

        sim.clearInt32Signal("activarBrazo")
    end


    -- MAQUINA DE ESTADOS (SECUENCIA COMPLETA)

    if estado == "idle" then
        
        sim.setJointTargetPosition(joint1, 0)
        sim.setJointTargetPosition(joint2, 0)

    elseif estado == "cerrar" then
        -- 1. cerrar dedo
        sim.setJointTargetPosition(joint1, math.rad(20))
        sim.setJointTargetPosition(joint2, 90)

        if t - tiempoInicio > 0.5 then
            estado = "empujar"
            tiempoInicio = t
        end

    elseif estado == "empujar" then
        -- 2. extender punta (empuje)
        sim.setJointTargetPosition(joint1, math.rad(90))
        sim.setJointTargetPosition(joint2, math.rad(0))

        if t - tiempoInicio > 0.5 then
            estado = "regresarPunta"
            tiempoInicio = t
        end

    elseif estado == "regresarPunta" then
        -- 3. regresar punta
        sim.setJointTargetPosition(joint1, math.rad(0))
        sim.setJointTargetPosition(joint2, 0)

        if t - tiempoInicio > 0.5 then
            estado = "abrir"
            tiempoInicio = t
        end

    elseif estado == "abrir" then
        -- 4. abrir dedo
        sim.setJointTargetPosition(joint1, 0)
        sim.setJointTargetPosition(joint2, 0)

        if t - tiempoInicio > 0.5 then
            estado = "idle"
        end
    end

end


function sysCall_sensing()
end


function sysCall_cleanup()
end
