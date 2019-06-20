$(document).on('turbolinks:load', function(){

  bsCustomFileInput.init()

  $("table.files").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,5], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });

  $("#payments").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,6], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });


  $("#users").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,5], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });

  $("#service-payments").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,8], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });

  $("#members").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,4], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });

})
