# Portal del Banco Aquarella

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

## Paso 3 — Revisión de calidad de código con SonarQube

Asumiendo que tenemos **SonarQube** instalado y correctamente configurado, podemos usarlo para revisar la calidad del código fuente de la aplicación.

SonarQube está preinstalado, acceda a él en http://localhost:9000/

Para ver el código de este paso:

```sh
git checkout master
git reset --hard paso-3
```

Se agrega una llamada a `runSonarQube` en el `Jenkinsfile`.  Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline. Una vez finalizado el pipeline, el reporte de calidad se puede observar en http://localhost:9000/

## Paso 4 — Ejecución de tests funcionales con Selenium

Para los tests de UI se recomienda usar identificadores únicos en el HTML. Con esto se simplifican los tests funcionales de Selenium.

```sh
git checkout master
git reset --hard paso-4
```

La ejecución de este paso requiere su propio pipeline. Por favor, [continúe aquí](https://github.com/orcilatam/selenium/) para completar el ejercicio.

## Paso 5 — Creación de artefacto y construción de imagen Docker

En términos generales, un _artefacto_ es un objeto binario que representa una aplicación, librería u otro recurso de una aplicación. Un artefacto consiste generalmente de un único archivo binario comprimido. Por ejemplo, para Java los packages `.jar`, `.ear` y `.war` se consideran artefactos.

Un artefacto tiene, además de un nombre, una *etiqueta* generalmente asociada con su número de versión. De esta manera es posible tener el mismo artefacto con distintas versiones.

Una imagen de Docker es simplemente un artefacto que representa una máquina virtual muy ligera. Para este curso, construiremos una imagen de Docker simple que contendrá:

- Un sistema operativo Debian mínimo (“slim”)
- La JDK 11, que incluye el servidor JSP Tomcat, para ejecutar archivos `.war`
- El package `.war` con el portal de Aquarella

Para ver estos cambios:

```sh
git checkout master
git reset --hard paso-5
```

Se agrega una llamada a `buildDockerImage` en el `Jenkinsfile`.  Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

## Paso 6 — Subida a Artifactory

Artifactory, como lo sugiere su nombre, es un repositorio central de artefactos. En este paso se tomará la imagen Docker creada localmente y se subirá a una instancia de Artifactory en la nube.

Para ver el nuevo stage:

```sh
git checkout master
git reset --hard paso-6
```

Se agrega una llamada a `pushImageToArtifactory` en el `Jenkinsfile`.  Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

El servidor de artifactory está en la nube, se puede acceder a él en http://artifactory:8082/artifactory. Use el usuario `estudiante`.

## Paso 7 — Despliegue a Kubernetes

Kubernetes es un sistema de orquestación de contenedores para automatizar el despliegue, el escalado y la gestión de aplicaciones que actúan en conjunto en un *cluster*.

Para este curso, desplegaremos a un *cluster* predefinido en Digital Ocean. El despliegue a Kubernetes requiere agregar al menos dos archivos YAML con la descripción del cluster: `service.yaml` y `deployment.yaml`.

Para ver los archivos en el nuevo stage:

```sh
git checkout master
git reset --hard paso-7
```

Se agregan (entre otras cosas) llamadas a  `deployToKubernetes` en el `Jenkinsfile`.  Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

El resultado del despliegue puede observarse ejecutando:

```sh
kubectl get services
kubectl get deployments
kubectl get pods
POD=$( kubectl get pods | grep portal-aquarella | cut -d ' ' -f 1 )
kubectl get pod $POD
kubectl describe pod $POD
kubectl logs -f pod $POD
kubectl logs -f $POD
```

## Paso 8 — Configuración de Ingress

Los despliegues del paso anterior no son visibles fuera del cluster de Kubernetes. Para exponer el cluster al mundo, lo usual es proveerle un punto de entrada controlado denominado **Ingress**.

Este consiste de un *web front* (también llamado *reverse proxy*) que acepta las peticiones HTTP de internet y las encamina hacia un Servicio Kubernetes en el proxy. Ingress es una definición genérica; la implementación concreta se basa en un **Ingress Controller**.

El Ingress Controller para nuestro ejemplo se basa en un servidor **Nginx** con balanceo de carga. Para instalar el Ingress Controller, se usará **Helm**.

Helm es un gestor de paquetes para Kubernetes. Este permite instalar y pre-configurar un grupo relacionado de servicios, deployments, configuraciones y recursos de Kubernetes como una unidad en lugar de tener que aplicar manifiestos de Kubernetes uno por uno.

Para ver los archivos en el nuevo stage:

```sh
git checkout master
git reset --hard paso-8
```

Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

Nótese que incluso después de instalar el Ingress Controller la aplicación continúa inaccesible desde internet. Es necesario completar dos pasos adicionales con los DNS que generalmente se ejecutan manualmente:

- Registrar un dominio público y apuntar los DNS a DigitalOcean. Para nuestro ejemplo usaremos el dominio `parroquiano.info`, que ya apunta a `ns{1,2,3}.digitalocean.com`
- Crear un subdominio DNS `aquarella.parroquiano.info` que apunte al Ingress Controller creado con Helm (usar TTL 300)

