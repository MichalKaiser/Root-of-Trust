for i in range(32):
    state_name = f'ST_OBFC{i:02d}'
    next_state = f'ST_OBFC{i + 1:02d}' if i < 31 else ''
    
    print(f'{state_name}: begin')
    print('\tif(data_i[{}]==FSM[{}]) begin'.format(31 - i, 31 - i))
    if i == 0:
        print('\t\tOBFC_correct = 1;')
    else:
        print('\t\tOBFC_correct = 0;')
    print(f'\t\tnext_state = {next_state};')
    print('\tend')
    print('\telse begin')
    print('\t\tOBFC_correct = 0;')
    print(f'\t\tnext_state = {next_state};')
    print('\tend')
    print('end')


    # Starting value for ST_ENC_ENC1 in binary
start_value = int('00100001', 2)

# Generate values from ST_ENC_ENC2 to ST_ENC_ENC31
for i in range(1, 31):
    value = start_value + i
    binary_value = format(value, '07b')  # Convert to 7-bit binary string
    print(f"localparam ST_PUF_ENC{i+1} = 7'b{binary_value};")

for i in range(32):
    print(f"ST_PUF_ENC{i}: begin")
    print(f"\tif (status_register[30] == 1) begin")
    print(f"\t\tif (address == enc_PUF_signature_address{i+1}) begin")
    print("\t\t\tif (re == 1) begin")
    print(f"\t\t\t\tassign data_o = enc_PUF_signature[{i*32+31}:{i*32}];")
    print(f"\t\t\t\tnext_state = ST_PUF_ENC{i+1};")
    print("\t\t\tend")
    print("\t\t\telse if (we == 1) begin")
    print("\t\t\t\tnext_state = ST_IDLE;")
    print("\t\t\tend")
    print("\t\t\telse begin")
    print("\t\t\t\tnext_state = ST_IDLE;")
    print("\t\t\tend")
    print("\t\tend")
    print("\tend")
    print("\telse begin")
    print("\t\tnext_state = ST_IDLE;")
    print("\tend")
    print("end")
    print()  # Extra newline for readability
