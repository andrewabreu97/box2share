$(document).on('turbolinks:load', function(){

  bsCustomFileInput.init()

  $("#files").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,4], "orderable": false, "searchable": false}
    ],
    "language": {
      "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
    }
  });

  $("#folder").dataTable({
    "order": [[ 1, "asc" ]],
    "columnDefs": [
      { "targets": [0,4], "orderable": false, "searchable": false}
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

})
