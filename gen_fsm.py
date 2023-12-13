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