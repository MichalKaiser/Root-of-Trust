def generate_verilog_code():
    j = 3
    for i in range(29, -1, -1):
        print(f"ST_FSM{j-1}: begin")
        print(f"\tif(address == 32'h1000_0081 && data_i[{i}]==FSM[{i}]) begin")
        print(f"\t\tstatus_register_mem = 32'b11;")
        print(f"\t\tnext_state <= ST_FSM{j};")
        print(f"\tend")
        print(f"\telse if(address == 32'h1000_0081 && data_i[{i}]!=FSM[{i}]) begin")
        print(f"\t\tFSM_correct = 0;")
        print(f"\t\tstatus_register_mem = 32'b11;")
        print(f"\t\tnext_state = ST_FSM{j};")
        print(f"\tend")
        print(f"\telse if(address != 32'h1000_0081) begin")
        print(f"\t\tnext_state = ST_START; //?????????, should be like this?")
        print(f"\tend")
        print(f"end")
        j= j+1

generate_verilog_code()