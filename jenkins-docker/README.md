# Utilizando Jenkins com Docker

Exemplo de como utilizar Jenkins para automatizar a execução de algum processo. Neste caso temos um script que faz uma chamada na API que retorna a cotação do dolar e salva o resultado em um arquivo csv. Utilizando o Jenkins em um contêiner Docker podemos automatizar a execução desse script para que ele possa ser executado de forma automática em um intervalo pré-determinado.  

[Documentação oficial](https://github.com/jenkinsci/docker/blob/master/README.md)  
[CRON GURU](https://crontab.guru/)

## História do Jenkins
O projeto Jenkins foi iniciado em 2004 (originalmente chamado de Hudson), por Kohsuke Kawaguchi, enquanto ele trabalhava para a Sun Microsystems. Kohsuke era um desenvolvedor da Sun e se cansou de causar a ira da sua equipe toda vez que o seu código quebrava a compilação. Ele criou o Jenkins como uma forma de realizar integração contínua – ou seja, testar o seu código antes de fazer um commit real no repositório, para ter certeza de que tudo estava bem. Assim que os seus companheiros viram o que ele estava fazendo, todos quiseram usar o Jenkins. Kohsuke abriu o código, criando o projeto Jenkins, e logo o uso do Jenkins se espalhou pelo mundo.

## Comandos Docker
listar as imagens: `docker image ls`  
remover imagem: `docker image rm <ID>`  
listar containers rodando: `docker ps`  
Executar comando para acesso ssh ao container: `docker exec -it 3cdb7385c127 bash -l`  