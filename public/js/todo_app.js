$(document).ready(function() {
  $('input.done-checkbox').click(function () {
    var $li = $(this).parents('li');
    var taskId = $li.data('id');
    var ticked = $(this).is(':checked');
    var action = ticked ? '/complete' : '/uncomplete'
    $.post('/todos/' + taskId + action, null, function() {
      $li.toggleClass('completed');
    });
  }); 
});