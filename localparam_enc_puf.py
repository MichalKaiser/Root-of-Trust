# Starting and ending addresses in binary
start_address_bin = '00010000000000000000000000101101'
end_address_bin = '00010000000000000000000001001100'

# Convert binary addresses to integers
start_address = int(start_address_bin, 2)
end_address = int(end_address_bin, 2)

# Calculate the step size
step = (end_address - start_address) // 31

# Generate addresses
addresses = [start_address + i * step for i in range(32)]

# Convert addresses back to binary and format as localparam statements
localparams = ["localparam enc_PUF_signature_address{} = 32'b{:032b};".format(i + 1, addr) for i, addr in enumerate(addresses)]

# Print the localparam statements
for param in localparams:
    print(param)