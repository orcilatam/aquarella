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

## Paso 5 — Creación de artefacto y construcción de imagen Docker

En términos generales, un _artefacto_ es un objeto binario que representa una aplicación, biblioteca u otro recurso de una aplicación. Un artefacto consiste generalmente de un único archivo binario comprimido. Por ejemplo, para Java los packages `.jar`, `.ear` y `.war` se consideran artefactos.

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

## Paso 9 — Prometheus y Grafana

**Prometheus** es una base de datos para series de tiempo. Esto quiere decir que está optimizada para guardar eficientemente series de datos con *timestamps* y produce resultados rápidos para consultas basadas en intervalos de tiempo. Esto la hace ideal para guardar métricas de hardware, como uso de disco, CPU y red.

Se suele usar en conjunción con **Grafana**, un producto para construir *dashboards* de visualización de métricas en tiempo real. Ambos constituyen una alternativa muy usada para monitorear clusters de Kubernetes.

Prometheus y Grafana se pueden instalar directamente en el marketplace del cluster de Kubernetes de Digital Ocean.  Para acceder a los dashboards de Grafana, avance hasta el paso 9.

```sh
git checkout master
git reset --hard paso-9
```

Y luego ejecute un utilitario para levantar un acceso local vía port forwarding:

```sh
cd ~/curso/aquarella
./grafana 8084
```

Puede acceder a los dashboards en el navegador Firefox de la VM abra [http://locahost:8084/](http://locahost:8084/). Puede ingresar con el usuario `admin`.

## Paso adicional 10 — Infraestructura como código

En los pasos anteriores la infraestructura ya se asumía instalada. La instalación de ésta generalmente se gestiona a través de **Terraform**.

```sh
git checkout master
git reset --hard paso-10
```

La ejecución de este paso requiere su propio pipeline. Por favor, [continúe aquí](https://github.com/orcilatam/iac/) para completar el ejercicio.

## Paso adicional 11 — Verificación de vulnerabilidades

OWASP (Open Web Application Security Project) es una fundación sin fines de lucro que publica herramientas y manuales para difundir buenas prácticas de seguridad. **Dependency Check** es un utilitario open source creado por OWASP para detectar vulnerabilidades conocidas en las *dependencias* de un proyecto. Por *dependencias* se entienden todas las bibliotecas, utilitarios y otros proyectos de base encima de las cuales se construye una aplicación. Dependency Check puede analizar una aplicación para determinar si alguna de sus dependencias contiene vulnerabilidades documentadas (conocidas como **CVE** o Common Vulnerabilities and Exposures en la jerga de seguridad) y cuáles son las posibles soluciones (conocidas como **mitigaciones** en la jerga). Dependency Check se conecta a una base de datos de OWASP en internet para mantenerse constantemente actualizado con las nuevas CVEs que se descubren y publican casi a diario. En internet es posible consultar las CVEs, si se conoce su número identificador, en [https://cve.mitre.org/](https://cve.mitre.org/)

La verificación de dependencias es sólo uno de los muchos aspectos de seguridad que pueden aparecer en DevOps. De hecho, muchas organizaciones ya hablan de  *DevSecOps* (Development, Security and Operations). Entre estos aspectos tenemos, además de las verificaciones de dependencias, el análisis estático del código de la aplicación para detectar prácticas inseguras (nótese que SonarQube ya emite un reporte de este aspecto), el análisis de comportamiento dinámico de una aplicación en producción, los tests de penetración (pentests) ejecutados por hackers éticos, el establecimiento y revisión de perímetros de seguridad web usando WAFs (Web Application Firewalls), etc.

Una exploración de todos estos aspectos está fuera del alcance de este curso introductorio. Sin embargo, la combinación de SonarQube y Dependency Check asegura una base mínima suficiente para la verificación de vulnerabilidades más comunes.

Para ver cómo incorporar Dependency Check a un nuevo stage:

```sh
git checkout master
git reset --hard paso-11
```

Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

Una vez concluido el pipeline haga clic en el número de Build. Al lado izquierdo aparece un link al reporte de Dependency Check.

## Paso adicional 12 — Notificaciones a Slack

Una característica útil de Jenkins es la capacidad de enviar notificaciones en vivo (vía un plugin) a un canal de Slack. Esto permite que otras personas observen y monitoreen la ejecución de un pipeline sin necesidad de ingresar a Jenkins.

Para ver cómo incorporar notificaciones a Slack:

```sh
git checkout master
git reset --hard paso-12
```

Hacer clic en *Build Now* en Jenkins para ejecutar el pipeline.

Las notificaciones se envían al canal de Slack configurado en Jenkins.

## Paso adicional 13 — EFK (Elasticsearch, Fluentd, Kibana)

**Elasticsearch** es una maquinaria de búsqueda, con un base de datos incorporada especializada en texto. Permite almacenar, catalogar y buscar en grandes volúmenes de texto. Usualmente se usa capturar logs de sistemas y aplicaciones, y hacer búsquedas en éstos. **Kibana** es un herramienta de visualización de datos y de creación de _dashboards_ o paneles de información visual. En conjunto con Elasticsearch, provee una manera de analizar y visualizar logs. **Fluentd** es un utilitario recolector de datos. Funciona como un agente incrustado en un cluster de Kubernetes que extrae los logs del cluster y de los pods desplegados en éste, y los envía a una instancia de Elasticsearch para su procesamiento.

Elasticsearch, Fluentd y Kibana se usan casi siempre juntos, al punto que esta combinación se la considera una unidad y se la conoce como EFK. Históricamente, antes de Fluentd existía un producto llamado **Logstash** (por lo tanto antes se hablaba de ELK) que hacía las funciones de Fluentd. Sin embargo, debido a la superioridad técnica de Fluentd, este está remplazando a Logstash.

Nótese que EFK se considera como parte de la infraestructura del cluster, así que _no_ es parte del pipeline de CI/CD, pero sí podría ser considerado parte del IaC.

Para ver cómo desplegar EFK dentro de un cluster:

```sh
git checkout master
git reset --hard paso-13
```
Elasticsearch se despliega en uno o más pods (es decir, un _cluster de pods_ de Elasticsearch) configurados como un **StatefulSet**. Un StafulSet es simplemente un Deployment que anticipamos que _no_ va ser efímero, por lo cual Kubernetes realiza dos cosas:

- Los nombres generados de los pods no son cuasialeatorios, sino que siguen una secuencia numérica ordenada; es decir que los nombres son predecibles, lo cual permite referenciarlos a priori antes de desplegarlos.
- Kubernetes le permite a los pods solicitar volúmenes de escritura permanente (**volumeClaim**); éstos son simplemente espacios de almacenamiento persistente (sistemas de archivo) fuera de Kubernetes, que el StatefulSet puede usar para guardar su estado, de manera que éste se mantenga aún cuando los pods dejen de existir.

Adicionalmente, es necesario desplegar un **Service** para abstraer el cluster de pods de Elasticsearch en una entidad abstracta.

Para desplegar Elasticsearch:

```sh
kubectl apply -f elasticsearch.yaml
```

Esto levanta una instancia de Elasticsearch _dentro_ del cluster de Kubernetes. Elasticsearch es accesible vía un API REST. Si hacemos un port forwarding al puerto 9200 de localhost:

```sh
./elasticsearch 9200
```

Podemos abrir en un navegador `http://localhost:9200/_cluster/state?pretty`  y ver cómo responde Elasticsearch.  Usar `Ctrl+C` para detener el port forwarding.

Para instalar una instancia de Kibana:

```sh
kubectl apply -f kibana.yaml
```

Nótese que Kibana se despliega en forma tradicional: un Deployment y un Service asociado.

Si hacemos un port forwarding al puerto 5601 de localhost podemos ver la UI:

```sh
./kibana 5601
```

Abrir en el navegador: `http://localhost:5601/`.  Usar Ctrl+C para detener el port forwarding.

Finalmente, para desplegar Fluentd es necesario crear un **ServiceAccount** dentro de Kubernetes, asociarle un **ClusterRole** a este ServiceAccount para que puede leer datos de logs del cluster (y logs de aplicaciones dentro de los pods), y desplegar Fluentd como un **DaemonSet**. Un DaemonSet es simplemente un tipo de pod que se levanta y "adjunta" automáticamente a todos los nodos del cluster (uno por cada nodo). A medida que más nodos entran o salen del cluster, Kubernetes se asegura de crear o bajar los pods adjuntos de los DaemonSets. Los DaemonSets son ideales para crear servicios adicionales disponibles en cada nodo, sin necesidad de usar nodos especiales.

Para instalar Fluentd en todos los nodos de nuestro cluster:

```sh
kubectl apply -f fluentd.yaml

