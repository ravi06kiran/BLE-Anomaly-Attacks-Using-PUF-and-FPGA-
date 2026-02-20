// 1. Feature Extractor
module ble_feature_extractor (
    input clk, reset, data_valid,
    input [87:0] raw_packet_data,
    output reg [47:0] reg_mac_addr,
    output reg signed [7:0] reg_rssi,
    output reg [31:0] reg_iat,
    output reg out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_mac_addr <= 48'b0; reg_rssi <= 8'b0; reg_iat <= 32'b0; out <= 1'b0;
        end else if (data_valid) begin
            reg_mac_addr <= raw_packet_data[87:40];
            reg_rssi     <= raw_packet_data[39:32];
            reg_iat      <= raw_packet_data[31:0];
            out <= 1'b1;
        end else out <= 1'b0;
    end
endmodule


// 2. Anomaly Engine
module anomaly_engine (
    input clk,
    input [31:0] current_iat,
    input [31:0] threshold_iat,
    output reg flood_alert
);
    always @(posedge clk) begin
        if (current_iat < threshold_iat && current_iat != 0) flood_alert <= 1'b1;
        else flood_alert <= 1'b0;
    end
endmodule