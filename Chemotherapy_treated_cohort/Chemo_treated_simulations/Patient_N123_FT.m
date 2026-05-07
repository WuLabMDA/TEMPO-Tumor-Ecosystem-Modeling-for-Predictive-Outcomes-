%% MATLAB Script to Derive and Extract Time Series Features 

% Feature extraction for cell population time series data
function features = extractCellTimeSeriesFeatures(data)
    % Initialize cell array for column names
    columnNames = {'Cancer_Cells', 'Regulatory_T_Cells', 'Effector_T_Cells', ...
                   'Macrophages', 'Endothelial_Cells', 'Fibroblast'};
    
    % Initialize feature structure
    features = struct();
    
    % Process each cell type
    for i = 1:length(columnNames)
        cellType = columnNames{i};
        timeSeries = data.(cellType);
        
        % Basic statistical features
        features.(cellType).mean = mean(timeSeries);
        features.(cellType).std = std(timeSeries);
        features.(cellType).max = max(timeSeries);
        features.(cellType).min = min(timeSeries);
        features.(cellType).range = range(timeSeries);
        features.(cellType).median = median(timeSeries);
        features.(cellType).skewness = skewness(timeSeries);
        features.(cellType).kurtosis = kurtosis(timeSeries);
        
        % Area Under the Curve features
        features.(cellType).auc = calculateAUC(timeSeries);
        
        % Trend features
        features.(cellType).trend = calculateTrend(timeSeries);
        
        % Rate of change features
        features.(cellType).roc = calculateRateOfChange(timeSeries);
        
        % Autocorrelation features
        features.(cellType).autocorr = calculateAutocorrFeatures(timeSeries);
        
    end
end


function auc = calculateAUC(timeSeries)
    % Calculate normalized AUC value between 0 and 1
    
    % Time vector (assuming uniform time steps)
    t = 1:length(timeSeries);
    
    % Calculate the total AUC using trapezoidal numerical integration
    total_auc = trapz(t, timeSeries);
    
    % Calculate the maximum possible area (rectangle formed by max value and time length)
    max_possible_area = max(timeSeries) * length(timeSeries);
    
    % Normalize the AUC to be between 0 and 1
    if max_possible_area > 0
        auc = total_auc / max_possible_area;
    else
        auc = 0;
    end
end


function trend = calculateTrend(timeSeries)
    % Calculate linear trend
    x = 1:length(timeSeries);
    p = polyfit(x, timeSeries, 1);
    trend.slope = p(1);
    trend.intercept = p(2);
    
    % Calculate R-squared
    yfit = polyval(p, x);
    yresid = timeSeries - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(timeSeries)-1) * var(timeSeries);
    trend.rsquared = 1 - SSresid/SStotal;
end

function roc = calculateRateOfChange(timeSeries)
    % Calculate various rates of change
    diff_series = diff(timeSeries);
    
    roc.mean_change = mean(diff_series);
    roc.max_increase = max(diff_series);
    roc.max_decrease = min(diff_series);
    roc.std_change = std(diff_series);
    
    % Calculate percentage changes
    pct_changes = diff_series ./ timeSeries(1:end-1) * 100;
    roc.mean_pct_change = mean(pct_changes);
    roc.max_pct_increase = max(pct_changes);
    roc.max_pct_decrease = min(pct_changes);
end

function autocorr = calculateAutocorrFeatures(timeSeries)
    % Calculate custom autocorrelation
    maxLag = 10;
    n = length(timeSeries);
    
    % Center the time series
    centered = timeSeries - mean(timeSeries);
    
    % Calculate variance for normalization
    variance = var(timeSeries);
    
    % Initialize ACF array
    acf = zeros(maxLag + 1, 1);
    
    % Calculate ACF for each lag
    for lag = 0:maxLag
        % Calculate autocovariance
        autocovariance = zeros(n - lag, 1);
        for i = 1:(n - lag)
            autocovariance(i) = centered(i) * centered(i + lag);
        end
        acf(lag + 1) = mean(autocovariance) / variance;
    end
    
    % Store ACF (excluding lag 0)
    autocorr.acf = acf(2:end);
    
    % Calculate summary statistics of ACF
    autocorr.mean_acf = mean(abs(acf(2:end)));
    autocorr.max_acf = max(abs(acf(2:end)));
    
    % Calculate partial autocorrelation using Durbin-Levinson recursion
    pacf = zeros(maxLag, 1);
    for k = 1:maxLag
        % Initialize phi matrix for current order
        phi = zeros(k, 1);
        
        if k == 1
            phi(1) = acf(2) / acf(1);
        else
            % Previous phi values
            prev_phi = zeros(k-1, 1);
            for i = 1:k-1
                prev_phi(i) = phi_prev(i);
            end
            
            % Numerator calculation
            num = acf(k+1);
            for j = 1:k-1
                num = num - prev_phi(j) * acf(k-j+1);
            end
            
            % Denominator calculation
            den = acf(1);
            for j = 1:k-1
                den = den - prev_phi(j) * acf(j+1);
            end
            
            % Current PACF value
            phi(k) = num / den;
            
            % Update previous phi values
            for j = 1:k-1
                phi(j) = prev_phi(j) - phi(k) * prev_phi(k-j);
            end
        end
        
        % Store current phi values for next iteration
        phi_prev = phi;
        
        % Store PACF value
        pacf(k) = phi(k);
    end
    
    autocorr.pacf = pacf;
    autocorr.mean_pacf = mean(abs(pacf));
    autocorr.max_pacf = max(abs(pacf));
end



%Example usage:
data = readtable('Patient_123_simulation_results.csv');
features = extractCellTimeSeriesFeatures(data);


