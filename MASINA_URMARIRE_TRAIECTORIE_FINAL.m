% Parametrii
start_point = [0 0];            % Punct de start [x y]
end_point = [3 3];              % Punctul final [x y]
num_points = 100;               % Numarul de puncte pe linia care reprezinta traiectoria
dt = 0.1;                       % Timp
L = 0.5;                        % Dimensiune masina
v = 1;                          % Constanta de viteza

% Calcul traiectorie tinta (linie)
target_x = linspace(start_point(1), end_point(1), num_points);
target_y = linspace(start_point(2), end_point(2), num_points);

% Initializare stare masina
x = start_point(1);             % Pozitia x initiala
y = start_point(2);             % Pozitia y initiala
theta = atan2(end_point(2) - start_point(2), end_point(1) - start_point(1)); % Unghi initial vehicul pana la punctul final

% Creare forma masina
car_length = L * 0.8;
car_width = L * 0.4;
car_shape = [car_length/2, car_width/2;     % Colt dreapta fata
             car_length/2, -car_width/2;    % Colt stanga fata
             -car_length/2, -car_width/2;   % Colt stanga spate
             -car_length/2, car_width/2;    % Colt dreapta spate
             car_length/2, car_width/2];    % Punct inchidere forma masina

% Creare forma roti masina
wheel_radius = L * 0.1;
wheel_shape = wheel_radius * [cos(linspace(0, 2*pi, 20)); sin(linspace(0, 2*pi, 20))];

% Loop principal
for i = 1:num_points
    % Calcul distanta pana la punctul final curent
    dist_to_target = norm([x, y] - [target_x(i), target_y(i)]);
    
    % Verificare daca masina a atins punctul final curent
    while dist_to_target > 0.1
        % Control urmarire (calcul unghi directie)
        alpha = atan2(target_y(i) - y, target_x(i) - x) - theta;
        delta = atan2(2 * L * sin(alpha), dist_to_target);
        
        % Actualizare stare masina
        x = x + v * cos(theta) * dt;
        y = y + v * sin(theta) * dt;
        theta = theta + (v / L) * tan(delta) * dt;
        
        % Updatare calcul distanta pana la punctul final curent dupa o miscare
        dist_to_target = norm([x, y] - [target_x(i), target_y(i)]);
        
        % Plot vehicul si traiectorie
        plot(target_x, target_y, 'r.', 'MarkerSize', 10);
        hold on;
        
        % Plot forma masina
        rotated_car_shape = [cos(theta) -sin(theta); sin(theta) cos(theta)] * car_shape.';
        car_x = rotated_car_shape(1, :) + x;
        car_y = rotated_car_shape(2, :) + y;
        plot(car_x, car_y, 'b', 'LineWidth', 1);
        
        % Plot roti si pozitia lor la masina relativa
        front_left_wheel_x = x + (car_length/2) * cos(theta) + (car_width/2) * sin(theta);
        front_left_wheel_y = y + (car_length/2) * sin(theta) - (car_width/2) * cos(theta);
        front_right_wheel_x = x + (car_length/2) * cos(theta) - (car_width/2) * sin(theta);
        front_right_wheel_y = y + (car_length/2) * sin(theta) + (car_width/2) * cos(theta);
        rear_left_wheel_x = x - (car_length/2) * cos(theta) + (car_width/2) * sin(theta);
        rear_left_wheel_y = y - (car_length/2) * sin(theta) - (car_width/2) * cos(theta);
        rear_right_wheel_x = x - (car_length/2) * cos(theta) - (car_width/2) * sin(theta);
        rear_right_wheel_y = y - (car_length/2) * sin(theta) + (car_width/2) * cos(theta);
        
        plot(front_left_wheel_x, front_left_wheel_y, 'ko', 'MarkerSize', 4);
        plot(front_right_wheel_x, front_right_wheel_y, 'ko', 'MarkerSize', 4);
        plot(rear_left_wheel_x, rear_left_wheel_y, 'ko', 'MarkerSize', 4);
        plot(rear_right_wheel_x, rear_right_wheel_y, 'ko', 'MarkerSize', 4);
        
        hold off;
        axis equal;
        title('Masina Urmarire Traiectorie FINAL');
        xlabel('X');
        ylabel('Y');
        xlim([-1 4]);
        ylim([-1 4]);
        drawnow;
        
        % Pauza pentru vizualizare (0.1 sec optim)
        pause(0.1);
    end
end
