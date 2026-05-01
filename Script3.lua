function sysCall_init()
    sim = require('sim')

    sensor = sim.getObject('/sensorRay')
    conveyor = sim.getObject('/conveyor')

    lastDetected = -1
    detener = false
    velocidadNormal = 0.1
end


function sysCall_sensing()
    local result, distance, detectedPoint, detectedObjectHandle = sim.readProximitySensor(sensor)

    if result > 0 and detectedObjectHandle ~= -1 then
        
        if detectedObjectHandle ~= lastDetected then
            
            local name = sim.getObjectAlias(detectedObjectHandle, 1)
            print("Detectado: " .. name)

            if string.find(name, "verde") then
                print("?? Verde detectado ? detener banda + activar robot")

                -- Se?al al robot
                sim.setInt32Signal("activarBrazo", 1)

                -- Activar paro
                detener = true
            end

            lastDetected = detectedObjectHandle
        end

    else
        lastDetected = -1
        detener = false
    end
end


function sysCall_actuation()

    if detener then
        -- ?? Paro fuerte (cada ciclo)
        sim.setBufferProperty(conveyor, 'customData.__ctrl__',
            sim.packTable({vel=0, pos=0})
        )
    else
        -- ?? Movimiento normal
        sim.setBufferProperty(conveyor, 'customData.__ctrl__',
            sim.packTable({vel=velocidadNormal})
        )
    end

end


function sysCall_cleanup()
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- See the user manual or the available code snippets for additional callback functions and details
