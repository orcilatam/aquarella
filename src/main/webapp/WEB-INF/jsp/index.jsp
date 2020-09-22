<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <title>Banco Aquarella</title>
</head>
<body>
  <div class="container m-5">
    <div class="row">
      <div class="col-md-4">
        <a href="/index"><img src="/img/banco-aquarella.png" class="rounded mx-auto d-block" alt="Banco Aquarella"></a>
      </div>
      <div class="col-md-8">
        <div class="alert alert-info" role="alert">
          Bienvenido al Banco Aquarella, por favor ingrese su RUT o DNI para consultar su saldo.
        </div>
        <form action="/saldo" method="get">
        <div class="form-group">
            <label for="userid">RUT/DNI</label>
            <input type="text" class="form-control" placeholder="00000000" id="userid" name="userid">
        </div>
        <button type="submit" class="btn btn-primary" id="ingresar">Ingresar</button>
        </form>
      </div>
    </div>
  </div>
  <script src="/js/jquery-3.4.1.min.js"></script>
  <script src="/js/bootstrap.bundle.min.js"></script>
</body>
</html>
