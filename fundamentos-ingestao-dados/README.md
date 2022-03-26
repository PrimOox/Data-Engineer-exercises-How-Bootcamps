# APIs e Requests

O Script `main.py` demonstra a utilização da API para capturar a cotação de moedas, assim como tem exemplos de tratativa de erros, retentativas e logs. Os arquivos `imoveis.py` e `podcast.py` também dão outros exemplos de ingestão de dados.

## Docs de introdução a APIs e Requests

- [Doc Python Requests](https://docs.python-requests.org/en/master/)
- [API de Cotações de Moedas](https://docs.awesomeapi.com.br/api-de-moedas)

## Tratando erros / retentativas

- [Documentação sobre Exceptions - Python Docs](https://docs.python.org/3/library/exceptions.html)
- [Exception and Error Handling in Python - DataCamp](https://www.datacamp.com/community/tutorials/exception-handling-python)
- [Pacote backoff utilizado para tratar melhor os erros e fazer retentativas](https://pypi.org/project/backoff/)

## Criando logs
```python
import logging 
 
log = logging.getLogger() 
log.setLevel(logging.DEBUG) 
formatter = logging.Formatter( 
'%(asctime)s - %(name)s - %(levelname)s - %(message)s') 
 
ch = logging.StreamHandler() 
ch.setFormatter(formatter) 
log.addHandler(ch) 
 
import logging 
logging.getLogger('backoff').addHandler(logging.StreamHandler())
```
