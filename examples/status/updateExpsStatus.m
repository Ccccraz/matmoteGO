function updateExpsStatus()
    % Get experiment status object
    cagelabStatus = matmoteGO.status();
    
    % Display initial status
    currentStatus = cagelabStatus.getStatus();
    fprintf('\n═══════════════════════════════════════════════\n');
    fprintf('           EXPERIMENT STATUS MONITOR\n');
    fprintf('═══════════════════════════════════════════════\n');
    fprintf('Initial Status:\n');
    disp(currentStatus.Body.Data);
    fprintf('\n═══════════════════════════════════════════════\n');
    
    % Start experiment
    fprintf('\n🚀 Starting experiment...\n');
    pause(1);
    
    % Update to running status
    currentStatus = cagelabStatus.updateStatusToRunning();
    fprintf('Current Status:\n');
    disp(currentStatus.Body.Data);
    fprintf('✅ Experiment is now running...\n');
    
    pause(1);
    
    % Stop experiment and display final status
    cagelabStatus.updateStatusToStopped();
    fprintf('\n═══════════════════════════════════════════════\n');
    fprintf('🛑 Experiment completed!\n');
    
    pause(1);
    
    currentStatus = cagelabStatus.getStatus();
    fprintf('Final Status:\n');
    disp(currentStatus.Body.Data);
    
    fprintf('═══════════════════════════════════════════════\n');
    fprintf('           MONITORING COMPLETE\n');
    fprintf('═══════════════════════════════════════════════\n\n');
end