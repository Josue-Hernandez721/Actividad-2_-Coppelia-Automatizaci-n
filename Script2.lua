function sysCall_init()
    lastTime = 0
    interval = 3 -- segundos

    -- Handle del objeto padre (el Dummy)
    dummyHandle = sim.getObject('.')
end

function sysCall_actuation()
    local t = sim.getSimulationTime()

    if (t - lastTime) >= interval then
        lastTime = t
        crearCubo()
    end
end

function crearCubo()
    local size = 0.1

    -- Crear cubo
    local cube = sim.createPureShape(0, 8, {size, size, size}, 0.1, nil)

    -- Colocarlo en la posici?n del Dummy
    local pos = sim.getObjectPosition(dummyHandle, -1)
    sim.setObjectPosition(cube, -1, pos)

    -- Tambi?n igualar orientaci?n (opcional pero recomendable)
    local ori = sim.getObjectOrientation(dummyHandle, -1)
    sim.setObjectOrientation(cube, -1, ori)

    -- Aleatorio rojo o verde
    if math.random() < 0.5 then
        -- VERDE
        sim.setShapeColor(cube, nil, sim.colorcomponent_ambient_diffuse, {0, 1, 0})
        sim.setObjectAlias(cube, "verde", 1)
    else
        -- ROJO
        sim.setShapeColor(cube, nil, sim.colorcomponent_ambient_diffuse, {1, 0, 0})
        sim.setObjectAlias(cube, "rojo", 1)
    end

    -- Detectable por sensores
    sim.setObjectSpecialProperty(cube, sim.objectspecialproperty_detectable_all)

    -- Din?mico (para que interact?e con f?sica)
    sim.setObjectInt32Param(cube, sim.shapeintparam_static, 0)
end
function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- See the user manual or the available code snippets for additional callback functions and details
