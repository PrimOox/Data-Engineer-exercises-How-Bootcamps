# Capturando dados de uma API: Ingestão de Dados com Scripts Escaláveis e Orientação a Objetos

Projeto de ingestão de dados da [API do mercado bitcoin](https://www.mercadobitcoin.com.br/api-doc/) que funciona de forma escalável, com checkpoints, seguindo os princípios do [SOLID](https://medium.com/@viniciuschan/solid-com-python-entendendo-os-5-princ%C3%ADpios-na-pr%C3%A1tica-f2af330b7751#:~:text=A%20principal%20id%C3%A9ia%20%C3%A9%20que,opera%C3%A7%C3%A3o%20conhecida%20como%20Monkey%2DPatching%20.), orientado a objetos e com cobertura de testes. Também temos o [Zappa](https://pythonforundergradengineers.com/deploy-serverless-web-app-aws-lambda-zappa.html#deploy-on-aws) configurado para mandar a execução do código na AWS Lambda.  

## SOLID
- [S] Single-responsiblity principle — Princípio da responsabilidade única: Cada classe deve ter uma única responsabilidade.
- [O] Open-closed principle — Princípio Aberto/Fechado: Entidades devem ser aberta para extensão, mas fechada para modificação.
- [L] Liskov substitution principle — Princípio da substituição de Liskov: Uma classe derivada deve ser substituível por sua classe base.
- [I] Interface segregation principle — Princípio da segregação de interfaces: Uma classe deve conter apenas as operações que são relevantes para o seu uso.
- [D] Dependency inversion principle — Princípio da inversão de dependência: Uma classe deve ser independente de suas dependências.
