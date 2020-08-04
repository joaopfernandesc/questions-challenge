# Desafio de Busca de Questões 
![alt text](https://github.com/sifthedog/questions-challenge/blob/master/pic.png?raw=true)

Esta é uma solução elaborada com Ruby On Rails para um desafio de busca de questões e disciplinas. 

Existem três endpoints diferentes com as possíveis informações:
- Lista ordenada das disciplinas com mais acessos nas últimas 24 horas;
- Todas as disciplinas que tenham as 10 questões "mais quentes" das últimas 24 horas;
- As questões mais acessadas na semana/mês/ano;

## Hipóteses
---
- Ao analisar os arquivos `.json` fornecidos, nota-se que algumas questões diferentes compartilhavam do mesmo `id`. Sendo assim, foram gerados novos arquivos e atribuída nova identificação. Os arquivos estão no repositório com o prefiro `new_`;
- Para os cálculos de acessos das últimas 24 horas, o campo `daily_access` foi considerado;

## Documentação
---
A documentação dos endpoints está disponível no [Swagger](https://app.swaggerhub.com/apis-docs/joaofernandes/Questions/v0.0.1).

## Como executar
---
Este projeto utiliza [Docker](https://www.docker.com/), portanto, para conseguir executá-lo, é necessário primeiro ter instalado o Docker e o Docker-Compose. Siga o passo-a-passo que está no site fornecido. É recomendado que, se estiver usando Linux, faça os passos para que Docker possa ser executado sem necessitar do `sudo`.

Com o Docker instalado, abra o terminal na pasta do repositório e execute:

`sh build.sh`

Pronto. Este script irá realizar todas as configurações necessárias. A primeira inicialização deve demorar um pouco, pois há 2 partes:
- execução de comandos no terminal, que fica visível ao usuário;
- execução de comandos dentro do container (migration, seed), que apenas são visíveis utilizando o comando `docker logs <id_do_container>`;

Após a inicialização, o seu container deve poder ser acessado na porta 3000. 
