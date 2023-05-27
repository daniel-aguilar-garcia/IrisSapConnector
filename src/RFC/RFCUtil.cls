Class RFC.RFCUtil
{

ClassMethod TestConnection() [ Language = python ]
{
  try:
    # Import python libraries
    from pyrfc import Connection, ABAPApplicationError, ABAPRuntimeError, LogonError, CommunicationError
    from configparser import ConfigParser

    # Connect to the SAP Server
    config = ConfigParser()
    config.read('/opt/irisapp/sapnwrfc.cfg')
    params_connection = config._sections['connection']
    conn = Connection(**params_connection)

    # Launch RFC call to STFC_CONNECTION
    result = conn.call('STFC_CONNECTION', REQUTEXT=u'Hello SAP!')

    # Close the connection
    conn.close()

    # Print the result
    print(result)

  except Exception as e:
    print(e)
}

ClassMethod GetDataTableSFLIGHT() [ Language = python ]
{
  try:
    # Import python libraries
    from pyrfc import Connection, ABAPApplicationError, ABAPRuntimeError, LogonError, CommunicationError
    from configparser import ConfigParser

    # Connect to the SAP Server
    config = ConfigParser()
    config.read('/opt/irisapp/sapnwrfc.cfg')
    params_connection = config._sections['connection']
    conn = Connection(**params_connection)

    # Define query parameters
    params = {
        'QUERY_TABLE': 'SFLIGHT',
        'DELIMITER': ',',
        'FIELDS': [
            {'FIELDNAME': 'CARRID'}, 
            {'FIELDNAME': 'CONNID'}, 
            {'FIELDNAME': 'FLDATE'}, 
            {'FIELDNAME': 'PRICE'}
        ],
        'OPTIONS': [],
    }

    # Call to función RFC 'RFC_READ_TABLE'
    result = conn.call('RFC_READ_TABLE', **params)

    # Process results
    if 'DATA' in result:
        data = result['DATA']
        fields = result['FIELDS']
        
        # Imprime los nombres de campo
        for field in fields:
            print(field['FIELDNAME'], end='\t')
        print()
        
        # Imprime los datos
        for entry in data:
            values = entry['WA'].split(',')
            for value in values:
                print(value, end='\t')
            print()
    else:
        print('No data found.')

    # Close SAP connection
    conn.close()

  except CommunicationError:
    print("Could not connect to server.")
    raise
  except LogonError:
    print("Could not log in. Wrong credentials?")
    raise
  except (ABAPApplicationError, ABAPRuntimeError):
    print("An error occurred.")
    raise
  except Exception as e:
    print(e)
}

ClassMethod TestGetDataCustomer()
{
  Do ..GetDataCustomer("08FRB478")
}

ClassMethod GetDataCustomer(clientSapID As %String) [ Language = python ]
{
  try:
    from pyrfc import Connection, ABAPApplicationError, ABAPRuntimeError, LogonError, CommunicationError
    from configparser import ConfigParser

    config = ConfigParser()
    config.read('/opt/irisapp/sapnwrfc.cfg')
    params_connection = config._sections['connection']
    conn = Connection(**params_connection)

   # Define los parámetros para la consulta de la tabla SFLIGHT
    params = {
      'QUERY_TABLE': 'KNA1',
      'DELIMITER': ',',
      'FIELDS': [{'FIELDNAME': 'KUNNR'}, {'FIELDNAME': 'SORTL'}, {'FIELDNAME': 'TELF1'}],
      'OPTIONS': [{'TEXT': "KUNNR = '" + clientSapID + "'"}],  # Reemplaza '<id_del_cliente>' con el ID del cliente deseado
     
  }

  # Llama a la función RFC 'RFC_READ_TABLE' para obtener los datos de la tabla
    result = conn.call('RFC_READ_TABLE', **params)

  # Procesa los resultados
    if 'DATA' in result:
      data = result['DATA']
      fields = result['FIELDS']
      
      # Imprime los nombres de campo
      for field in fields:
          print(field['FIELDNAME'], end='\t')
      print()
      
      # Imprime los datos
      for entry in data:
          values = entry['WA'].split(',')
          for value in values:
              print(value, end='\t')
          print()
    else:
      print('No se encontraron datos.')

  # Cierra la conexión con SAP
    conn.close()

  except CommunicationError:
    print("Could not connect to server.")
    raise
  except LogonError:
    print("Could not log in. Wrong credentials?")
    raise
  except (ABAPApplicationError, ABAPRuntimeError):
    print("An error occurred.")
    raise
  except Exception as e:
    print(e)
}

}
