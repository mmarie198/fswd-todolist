import $ from 'jquery';

$.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

export var indexTasks = function (successCB, errorCB) {
  var request = {
    type: 'GET',
    url: 'api/tasks?api_key=1',
    success: successCB,
    error: errorCB
  }

  $.ajax(request);
};

indexTasks();

export var postTask = function (content, successCB, errorCB) {
    var request = {
      type: 'POST',
      url: 'api/tasks?api_key=1',
      data: {
        task: {
          content: content
        }
      },
      success: successCB,
      error: errorCB
    }
  
    $.ajax(request);
  };
  
