# Portal del Banco Aquarella

Esta es la rama de Marco.

![Banco Aquarella](https://raw.githubusercontent.com/orcilatam/aquarella/master/src/main/resources/static/img/banco-aquarella.png)

Proyecto de prueba para Curso práctico de DevOps de ORCI Latam.

## Paso 1 — Una aplicación Java aislada

Tenemos una aplicación en Java que ejecuta aislada localmente y en forma manual. Este es el punto de partida para cualquier desarrollo.

```sh
git clone https://github.com/orcilatam/aquarella.git
git checkout master
git reset --hard paso-1
```

Compile la aplicación localmente:

```sh
mvn clean compile
```

Ejecute los tests JUnit localmente:

```sh
mvn test
```

Cree un package (`.war`):

```sh
mvn package
```

Ejecute la aplicación:

```sh
java -jar target/portal-aquarella-*.war
```

Para ver la UI de la aplicación, en el navegador Firefox de la VM abra [http://localhost:9090/](http://localhost:9090/)
