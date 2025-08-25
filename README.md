## O que é docker compose ?

Docker Compose é uma ferramenta do Docker usada para definir e gerenciar aplicações multi-contêiner. Ela permite que você configure todos os serviços (como banco de dados, backend, frontend, etc.) que sua aplicação precisa, em um único arquivo (docker-compose.yml) — e depois inicie tudo com um único comando.

## Rodar o Docker Compose

Com o terminal aberto e na pasta correta, execute o seguinte comando para iniciar os serviços definidos no seu docker-compose.yml:

~~~
docker-compose up
~~~

Se você quiser rodar os containers em segundo plano (detached mode), use o comando:

~~~
docker-compose up -d
~~~

verifica se os comtainer estão rodando

~~~
docker ps
~~~

Lembrando que após a instalação do docker tem que colocar ele com permissão root, ou ficar dando sudo toda hora.

PARA ACESSAR O MODELO: http://localhost:16543

Para parar o docker-compose, você pode usar o seguinte comando diretamente no terminal:

~~~
docker-compose down
~~~

 - Encerra e remove os containers, a rede e os volumes definidos no docker-compose.yml.
 - Ele não apaga os dados persistidos se você estiver usando volumes mapeados no host (como no seu caso com o PostgreSQL).

Se quiser apenas pausar (sem remover os containers):

~~~
docker-compose stop
~~~

Isso apenas interrompe os containers, mas não os remove. Você pode retomá-los com:

~~~
docker-compose start
~~~

