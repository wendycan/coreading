var Annotator = {
  fields : [],
  annotations : []
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
  var html = '<div class="annotator-adder annotator-hide" style="display:none"><button type="button">' + '编辑' + '</button></div>';
  $('#annotator-wedget').html(html);
  Annotator.showWidget(position, $('.annotator-adder'));
  $('.annotator-adder button').click(function(e){Annotator.clickAdderBtn(annotation, position, e)});
},

Annotator.clickAdderBtn = function (annotation, position, e) {
  var html = [
    '<div class="annotator-outer annotator-editor annotator-hide">',
    '  <form class="annotator-widget">',
    '    <ul class="annotator-listing"></ul>',
    '    <div class="annotator-controls">',
    '     <a href="#cancel" class="annotator-cancel">' + 'Cancel' + '</a>',
    '      <a href="#save"',
    '         class="annotator-save annotator-focus">' + 'Save' + '</a>',
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
Annotator._onSaveClick = function (e, annotation) {
  console.log(annotation)
  var text = $('.annotator-item textarea').val();
  annotation.text = text;
  console.log(text)
  Highlighter.draw(annotation);
  this.annotations.push(annotation);
  $('#annotator-wedget').empty();
  //to create annotator
};
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
      placeholder: field.label
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
  var html = [
    '<div class="annotator-outer annotator-viewer annotator-hide">',
    '<ul class="annotator-widget annotator-listing">',
    '<li class="annotator-annotation annotator-item">',
    '  <span class="annotator-controls">',
    '    <a href="#"',
    '       title="' + 'View as webpage' + '"',
    '       class="annotator-link">' + annotation.text + '</a>',
    '    <button type="button"',
    '            title="' + 'Edit' + '"',
    '            class="annotator-edit">' + 'Edit' + '</button>',
    '    <button type="button"',
    '            title="' + 'Delete' + '"',
    '            class="annotator-delete">' + 'Delete' + '</button>',
    '  </span>',
    '</li>',
    '</ul>',
    '</div>'
  ].join('\n');
  $('#annotator-wedget').html(html);
  var offset = this.element.parent().offset(),
      position = {
          top: e.pageY - offset.top,
          left: e.pageX - offset.left
      };
  Annotator.showWidget(position, $('.annotator-viewer'));
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