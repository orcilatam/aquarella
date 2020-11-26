# Portal del Banco Aquarella

Esta es la rama de Ana.

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

## Paso 2 — Jenkins y un pipeline mínimo

Asumiendo que tenemos **Jenkins** instalado y correctamente configurado, podemos usarlo como infraestructura mínima para un pipeline.

Jenkins está preinstalado, acceda a él en http://localhost:8080/

Para ver el código de este paso:

```sh
git checkout master
git reset --hard paso-2
```

Se modifica `pom.xml` para que JUnit emita un reporte XML (esto se logra con el plugin Surefire de Maven).

Se agrega una *shared library* en Jenkins para uso de los pipelines. Ésta consta de una serie de funciones utilitarias en Groovy para uso de los pipelines. Para nuestro ejemplo usaremos https://github.com/orcilatam/sharedlib.

Se agrega un pipeline básico en un nuevo archivo archivo  `Jenkinsfile`; éste usa la shared library anterior. Aquí se observan las llamadas a los stages de compilación y ejecución de tests unitarios.

Se agrega en Jenkins un job del tipo *Multibranch pipeline* que apunte al repositorio de Aquarella.

Finalmente, hacer clic en *Build Now* en Jenkins.
