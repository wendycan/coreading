var Annotator = {
  fields : [],
  annotations : [],
  users: []
};
var NS = "annotator-editor";
var NSV = "annotator-viewer";

Annotator.textSelector = function (element, options) {
  this.element = element;
  // this.options = $.extend(true, {}, TextSelector.options, options);
  this.options = options;
  this.element
    .on("mouseup", function (e) {
        Annotator._checkForEndSelection(e);
    });
};

Annotator._checkForEndSelection = function(e){
  var range = this.captureDocumentSelection()[0];
  if(!range || range.text().length <= 0) return;
  var offset = this.element.parent().offset(),
  position = {
    top: e.pageY - offset.top,
    left: e.pageX - offset.left
  };
  annotation = {};
  annotation.range = range.serialize(this.element[0], '.annotator-hl');
  annotation.quote = range.text();
  var html = [
  '<div class="annotator-adder annotator-hide" style="display:none">',
  '<i class="fa fa-star"></i>',
  // '<i class="fa fa-underline"></i>',
  '<i class="fa fa-comment"></i>',
  '</div>'
  ].join('\n');
  $('#annotator-wedget').html(html);
  Annotator.showWidget(position, $('.annotator-adder'));
  $('.annotator-adder i.fa-comment').click(function(e){
    annotation.tag = 'comment';
    Annotator.clickAdderBtn(annotation, position, e)});
  $('.annotator-adder i.fa-star').click(function(e){
    annotation.tag = 'star';
    annotation.username = Annotator.options.account.username;

    $('#annotator-wedget').empty();
    Annotator.createAnnotation(annotation, function(data){
      annotation.id = data.id;
      annotation.updated_at = jQuery.timeago(data.updated_at);

      Highlighter.draw(annotation);
    });
  });
},

Annotator.clickAdderBtn = function (annotation, position, e) {
  var html = [
    '<div class="annotator-outer annotator-editor annotator-hide">',
    '  <form class="annotator-widget">',
    '    <ul class="annotator-listing"></ul>',
    '    <div class="annotator-controls">',
    '       <i class="fa fa-times-circle annotator-cancel"></i>',
    '       <i class="fa fa-check annotator-save primary-color"></i>',
    '    </div>',
    '  </form>',
    '</div>'
  ].join('\n');
  $('#annotator-wedget').html(html);
  this.addField({
    type: 'textarea'
  });
  Annotator.bindEvents(annotation);
  $('.annotator-editor').css({
    top: position.top,
    left: position.left
  });
};
Annotator.unbindEvents = function () {
  $(document).unbind('.' + NS);
};
Annotator.bindEvents = function (annotation) {
  Annotator.unbindEvents();
  var self = this;
  $(document).on("submit." + NS, 'form', function (e) {
      self._onFormSubmit(e);
  })
  .on("click." + NS, '.annotator-save', function (e) {
      self._onSaveClick(e,annotation);
  })
  .on("click." + NS, '.annotator-cancel', function (e) {
      self._onCancelClick(e);
  })
  .on("mouseover." + NS, '.annotator-cancel', function (e) {
      self._onCancelMouseover(e);
  })
  .on("keydown." + NS, 'textarea', function (e) {
      self._onTextareaKeydown(e);
  });
};
Annotator._onFormSubmit = function (e) {
  // console.log('submit');
};
Annotator.load = function() {
  var _this = this;
  var user = Annotator.options.account;
  $.ajax({
    url: '/api/v1/annotations',
    type: 'GET',
    headers: {
      'Auth-Token': user.auth_token
    },
    data: {
      article_id: Annotator.options.article.id
    },
    success: function(data){
      if (Annotator.options.article.public == 1) {
        data.forEach(function(d) {
          var anns = d.annotations;
          var username = d.username;
          Annotator.users.push(username);
          anns.forEach(function (ann) {
            ann.username = username;
            ann.updated_at = jQuery.timeago(ann.updated_at);
            Annotator.annotations.push(ann);
          })
        })
      } else {
        data.forEach(function(ann) {
          Annotator.annotations.push(ann);
        })
      }
      Annotator.annotations.forEach(function(annotation, index) {
        annotation.range = Range.sniff(JSON.parse(annotation.range));
        Highlighter.draw(annotation);
      });
      Annotator.renderAnnotationsMeta();
    },
    error: function(e) {
      console.log(e);
    }
  });
},
Annotator.renderAnnotationsMeta = function () {
  $('#annotations-count').text(Annotator.annotations.length);
  $('#annotations-count').attr('data-annotations-count', Annotator.annotations.length);
  if (Annotator.options.article.public == 1) {
    $('#annotations-users').html('<p><small>批注成员</small><span class="user-list"></span></p>');
    Annotator.users.forEach(function (username) {
      $('#annotations-users .user-list').append('<span class="label radius" data-username=' + username + '>' + username + '</span>');
    })
  };
},
Annotator._onSaveClick = function (e, annotation) {
  var text = $('.annotator-item textarea').val();
  annotation.text = text;
  this.annotations.push(annotation);
  // to create annotator
  $('#annotator-wedget').empty();
  annotation.username = Annotator.options.account.username;

  Annotator.createAnnotation(annotation, function(data){
    annotation.id = data.id;
    annotation.updated_at = jQuery.timeago(data.updated_at);

    Highlighter.draw(annotation);
  });
};
Annotator.createAnnotation = function (annotation, success, error) {
  var article = this.options.article;
  var user = this.options.account;
  $.ajax({
    url: '/api/v1/annotations',
    type: 'POST',
    headers: {
      'Auth-Token': user.auth_token
    },
    data: {
      text: annotation.text,
      quote: annotation.quote,
      range: JSON.stringify(annotation.range.toObject()),
      user_id: user.id,
      article_id: article.id,
      tag: annotation.tag
    },
    success: function(data){
      alertify.success("成功创建此批注");
      var count = parseInt($('#annotations-count').attr('data-annotations-count')) + 1;
      $('#annotations-count').attr('data-annotations-count', count);
      $('#annotations-count').text(count);
      if (success) {success(data)}
    },
    error: function(e) {
      alertify.success("批注创建失败，请稍后重试。");
      if (error) {error(e)}
    }
  });
};
Annotator.deleteAnnotation = function(annotation, success, error) {
  var user = this.options.account;
  $.ajax({
    url: '/api/v1/annotations/' + annotation.id,
    type: 'DELETE',
    headers: {
      'Auth-Token': user.auth_token
    },
    success: function(data){
      alertify.success("成功删除此批注");
      var count = parseInt($('#annotations-count').attr('data-annotations-count')) - 1;
      if (count < 0) {count = 0};
      $('#annotations-count').attr('data-annotations-count', count);
      $('#annotations-count').text(count);

      if (success) {success(data)}
    }, 
    error: function(e) {
      alertify.success("批注删除失败，请稍后重试。");
      if (error) {error(e)}
    }
  })
}
Annotator._onCancelClick = function (e) {
  $('#annotator-wedget').empty();
};
Annotator._onCancelMouseover = function (e) {
  // console.log('CancelMouseover');
};
Annotator._onTextareaKeydown = function (e) {
  // console.log('TextareaKeydown');
};
Annotator.addField = function (options) {
  var field = $.extend({
      id: 'annotator-field-' + 11,
      type: 'input',
      label: '',
      load: function () {},
      submit: function () {}
  }, options);

  var input = null,
      element = $('<li class="annotator-item" />');

  field.element = element[0];

  if (field.type === 'textarea') {
      input = $('<textarea />');
  } else if (field.type === 'checkbox') {
      input = $('<input type="checkbox" />');
  } else if (field.type === 'input') {
      input = $('<input />');
  } else if (field.type === 'select') {
      input = $('<select />');
  }

  element.append(input);

  input.attr({
      id: field.id,
      placeholder: '输入批注...'
  });

  if (field.type === 'checkbox') {
      element.addClass('annotator-checkbox');
      element.append($('<label />', {
          'for': field.id,
          'html': field.label
      }));
  }
  $(document).find('ul.annotator-listing').append(element);
  this.fields.push(field);

  return field.element;
};

Annotator.showWidget = function(position, el) {
  if (typeof position !== 'undefined' && position !== null) {
    el.css({
        top: position.top,
        left: position.left
    });
  }
  el.css('display', 'block');  
};

Annotator.getSelect = function() {
  range = getSelection().getRangeAt(0);
  bRange = new Range.BrowserRange(range);
  sRange = bRange.serialize(document.body);
  return sRange;
};

Annotator.hoveHighlights = function () {
  var self = this;
  $(document).on("mouseover." + NSV, '.annotator-hl', function (event) {
    self._onHighlightMouseover(event);
  })
  // .on("mouseleave." + NS, '.annotator-hl', function () {
  //   self._startHideTimer();
  // });
};

Annotator._onHighlightMouseover = function (e) {
  // if (this.mouseDown) {
  //     return;
  // }
  var annotation = $(e.target)
      // .parents('.annotator-hl')
      .addBack()
      .map(function (_, elem) {
          return $(elem).data("annotation");
      })
      .toArray()[0];
  var html;
  if (annotation.tag == 'comment') {
    html = [
      '<div class="annotator-outer annotator-viewer annotator-hide">',
      '<ul class="annotator-widget annotator-listing">',
      '<li class="annotator-annotation annotator-item">',
      '  <div class="annotator-controls">',
      '    <a href="#"',
      '       title="' + 'View as webpage' + '"',
      '       class="annotator-link">' + annotation.text + '</a>',
      '     <p>' + annotation.username + ' ' + annotation.updated_at + '添加</p>',
      '     <p class="text-right">',
      '       <i class="fa fa-pencil-square-o annotator-edit primary-color"></i>',
      '       <i class="fa fa-times-circle annotator-delete"></i>',
      '     </p>',
      '  </div>',
      '</li>',
      '</ul>',
      '</div>'
    ].join('\n');
  } else {
    html = ['<div class="annotator-outer annotator-viewer annotator-hide">',
      '<ul class="annotator-widget annotator-listing">',
      '<li class="annotator-annotation annotator-item">',
      '  <div class="annotator-controls">',
      '    <p>' + annotation.username + ' ' + annotation.updated_at + '添加</p>',
      '    <p class="text-right"><i class="fa fa-times-circle annotator-delete"></i></p>',
      '  </div>',
      '</li>',
      '</ul>',
      '</div>'
    ].join('\n');
  }
  $('#annotator-wedget').html(html);
  var offset = this.element.parent().offset(),
      position = {
          top: e.pageY - offset.top,
          left: e.pageX - offset.left
      };
  Annotator.showWidget(position, $('.annotator-viewer'));
  $('#annotator-wedget .annotator-delete').click(function(){
    Highlighter.undraw(annotation);
    $('#annotator-wedget').empty();
    Annotator.deleteAnnotation(annotation);
  });
};

Annotator.captureDocumentSelection = function () {
  var i,
      len,
      ranges = [],
      rangesToIgnore = [],
      selection = Util.getGlobal().getSelection();

  if (selection.isCollapsed) {
      return [];
  }

  for (i = 0; i < selection.rangeCount; i++) {
      var r = selection.getRangeAt(i),
          browserRange = new Range.BrowserRange(r),
          normedRange = browserRange.normalize().limit(this.element[0]);
      // If the new range falls fully outside our this.element, we should
      // add it back to the document but not return it from this method.
      if (normedRange === null) {
          rangesToIgnore.push(r);
      } else {
          ranges.push(normedRange);
      }
  }

  // BrowserRange#normalize() modifies the DOM structure and deselects the
  // underlying text as a result. So here we remove the selected ranges and
  // reapply the new ones.
  selection.removeAllRanges();

  for (i = 0, len = rangesToIgnore.length; i < len; i++) {
      selection.addRange(rangesToIgnore[i]);
  }

  // Add normed ranges back to the selection
  for (i = 0, len = ranges.length; i < len; i++) {
      var range = ranges[i],
          drange = document.createRange();
      drange.setStartBefore(range.start);
      drange.setEndAfter(range.end);
      selection.addRange(drange);
  }

  return ranges;
}
