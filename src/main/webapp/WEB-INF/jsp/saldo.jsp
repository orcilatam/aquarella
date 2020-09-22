<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <title>Banco Aquarella - Saldo</title>
</head>
<body>
  <div class="container m-5">
    <div class="row">
      <div class="col-md-4">
        <a href="/index"><img src="/img/banco-aquarella.png" class="rounded mx-auto d-block" alt="Banco Aquarella"></a>
      </div>
      <div class="col-md-8">
        <table class="table">
          <thead class="thead-light">
            <tr>
            <th scope="col">Nombre</th>
            <th scope="col">Saldo</th>
            </tr>
          </thead>
          <tbody>
            <tr>
            <td>${nombre}</td>
            <td id="saldo">${saldo}</td>
            </tr>
          </tbody>
        </table>
        <a href="/index" class="btn btn-primary" role="button">Regresar</a>
      </div>
    </div>
  </div>
  <script src="/js/jquery-3.4.1.min.js"></script>
  <script src="/js/bootstrap.bundle.min.js"></script>
</body>
</html>
