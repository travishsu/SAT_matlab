function f = hw_f1(x)

    % Variables: 1
    % Range:     [0, 1]


    if length(x)~=1
          error('Too many variables - function is for one varaible only');
    end
    if x<0 || x>1
          error('Variable outside of range - use x in {0,1}');
    end

    f =((x.*6-2).^2).*sin((x.*6-2).*2);
end
