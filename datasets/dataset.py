import pandas as pd
import numpy as np
import os
import pandas_profiling as pp
import csv, ast

def dataType(val, current_type):
  try:
      # Evaluates numbers to an appropriate type, and strings an error
      t = ast.literal_eval(val)
  except ValueError:
      return 'varchar'
  except SyntaxError:
      return 'varchar'
  if type(t) in [int, float]:
    if (type(t) in [int]) and current_type not in ['float', 'varchar']:
        # Use smallest possible int type
        if (-32768 < t < 32767) and current_type not in ['int', 'bigint']:
            return 'smallint'
        elif (-2147483648 < t < 2147483647) and current_type not in ['bigint']:
            return 'int'
        else:
            return 'bigint'
    if type(t) is float and current_type not in ['varchar']:
          return 'decimal'
  else:
      return 'varchar'

entries = os.listdir('datasets/')
for entry in entries:
    # if entry[len(entry)-3:] == "csv" and entry != 'olist_order_reviews_dataset.csv':
    if entry[len(entry)-3:] == "csv" and entry[:9] != 'cabeçalho':
        # print('Lendo o dataset: ', entry)
        dataset = entry[6-len(entry):-12]
        # print(dataset)
        f = open('datasets/'+entry, 'r')
        reader = csv.reader(f)
        longest, headers, type_list = [], [], []

        # if entry != 'olist_geolocation_dataset.csv':
        print('Lendo pandas csv...', entry)
        df = pd.read_csv('datasets/'+entry, sep=',')
        print('ProfileReport')
        profile = pp.ProfileReport(df, title=entry)
        print('Exportando html')
        profile.to_file(output_file='datasets/html/' + entry + '.html')
        print('Profile report ok\n')
    
        # It iterates over the rows in our CSV, calls the function above, and populates the lists.
        for row in reader:
            if len(headers) == 0:
                headers = row
                for col in row:
                    longest.append(0)
                    type_list.append('')
            else:
                for i in range(len(row)):
                    # print('Range:', row[i], ' | Row ', i, ' | Len ', len(row[i]), ' | Longest ', longest[i] )
                    # NA is the csv null value
                    if type_list[i] == 'varchar' or row[i] == 'NA':
                        if len(row[i]) > longest[i]:
                            longest[i] = len(row[i])
                        pass
                    else:
                        var_type = dataType(row[i], type_list[i])
                        type_list[i] = var_type

        f.close()

        # Then use those lists to write the SQL statement
        statement = 'create table ' + dataset + '('
        
        campos = ''
        for i in range(len(headers)):
            campos = campos + headers[i].lower() + ", "
            if type_list[i] == 'varchar':
                statement = (statement + '\n{} varchar({}),').format(headers[i].lower(), str(longest[i]))
            else:
                statement = (statement + '\n' + '{} {}' + ',').format(headers[i].lower(), type_list[i])

        statement = statement[:-1] + ');'

        # Finally, the output!
        print(campos, '\n')
        print(statement, '\n')