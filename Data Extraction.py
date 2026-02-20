import pandas as pd

try:
    df = pd.read_csv('ble_packet_table.csv')
except FileNotFoundError:
    print("Couldn't found file")

def generate_vectors(data, filename):
    # Convert Clock Frequency (e.g., 100MHz) to cycles
    clock_speed = 100_000_000 
    
    with open(filename, 'w') as f:
        for index, row in data.iterrows():
            # A. MAC Address Cleaning (48-bit)
            # Convert 'D0:EF:76...' to 'D0EF76...'
            mac = str(row['MAC']).replace(':', '').upper()
            
            # B. RSSI to 8-bit Signed Hex (2's complement)
            # RSSI is negative, so logic is required
            rssi = int(row['RSSI'])
            rssi_hex = format(rssi & 0xFF, '02X')
            
            # C. IAT (Inter-Arrival Time) logic
            # Use IAT column if present in CSV, otherwise use dummy
            iat_val = row.get('IAT', 0.1) # Default 0.1 sec if missing
            iat_cycles = int(float(iat_val) * clock_speed)
            iat_hex = format(iat_cycles & 0xFFFFFFFF, '08X')
            
            # D. Create Final Vector String (Format: MAC + RSSI + IAT)
            # Total 12 + 2 + 8 = 22 characters hex code
            final_vector = f"{mac}{rssi_hex}{iat_hex}"
            
            f.write(final_vector + '\n')
            
    print(f"Bhai, {filename} ready hai! Isme {len(data)} lines hain.")


generate_vectors(df, 'ble_hardware_vectors.mem')