function [velocity,velocityFieldFound] = findVelocity(log)
    
    fields = fieldnames(log);
    velocityFieldFound  = any(strcmp(fields,'VehicleSpeed'));
    if velocityFieldFound
    velocity       = log.VehicleSpeed;
    else
        velocityFieldFound  = any(strcmp(fields,'IVehicleSpeed'));
        if velocityFieldFound
        velocity       = log.IVehicleSpeed;
        else
            velocityFieldFound = any(strcmp(fields,'VelForward'));
            if velocityFieldFound
            velocity       = log.VelForward.*3.6;
            else
                velocityFieldFound = any(strcmp(fields,'Velocity'));
                if velocityFieldFound
                    velocity   = log.Velocity.*1.85;
                else
                    velocity   = NaN;
                end
            end
        end
    end
end
