module tb_ble_ids;
    reg clk, reset, data_valid;
    reg [87:0] raw_packet_data;
    wire [47:0] reg_mac_addr;
    wire signed [7:0] reg_rssi;
    wire [31:0] reg_iat;
    wire extraction_done, flood_alert;
    reg [87:0] test_memory [0:442]; 
    integer i;

    ble_feature_extractor FEU (clk, reset, data_valid, raw_packet_data, reg_mac_addr, reg_rssi, reg_iat, extraction_done);
    anomaly_engine IDS (clk, reg_iat, 32'h0000FFFF, flood_alert);

    always #5 clk = ~clk;

    initial begin
      $dumpfile("data.vcd");
        $dumpvars(0, tb_ble_ids);
      
        $readmemh("ble_hardware_vectors.mem", test_memory);
        clk = 0; reset = 1; data_valid = 0;
        #20 reset = 0;

        // Loop through all 443 packets from your previous project
        for (i = 0; i < 443; i = i + 1) begin
            @(posedge clk);
            raw_packet_data = test_memory[i];
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            #50;
        end
      
//         clk = 0; reset = 1; data_valid = 0;
//         #20 reset = 0;
//         @(posedge clk);
//         raw_packet_data = 88'hD0EF76450F66_DA_00989680;
//         data_valid = 1;
//         @(posedge clk); data_valid = 0;
        
//         #100;
//         @(posedge clk);
//         raw_packet_data = 88'hD0EF76450F66_BD_00000100;
//         data_valid = 1;
//         @(posedge clk); data_valid = 0;

        #200 $finish;
    end
endmodule